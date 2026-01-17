class Order < ApplicationRecord
  INVOICING_START_DATE = Date.new 2024, 2, 3

  belongs_to :event
  has_many :tickets
  has_one :invoice_sequence, through: :event
  has_one :invoice
  has_one :credit_note, through: :invoice, source: :refund

  def self.completed = where("completed_at IS NOT NULL")

  def stripe
    @stripe ||= stripe_checkout_session && Stripe::Checkout::Session.construct_from(stripe_checkout_session)
  end

  def customer_vat_idx = stripe.customer_details.tax_ids.first&.value
  def customer_country = stripe.customer_details.address.country

  def customer_address
    stripe.customer_details.address.line1 ||
      "#{stripe.customer_details.address.city} #{stripe.customer_details.address.postal_code}"
  end

  def refunded? = refunded_amount.positive?
  def fully_refunded? = refunded? && refunded_amount == amount

  def invoicable? = issue_invoice? && completed_at.after?(INVOICING_START_DATE)

  def expire!(checkout_session)
    update! expired_at: Time.current,
            stripe_checkout_session: checkout_session.as_json
  end

  def complete!(checkout_session)
    transaction do
      update! completed_at: Time.current,
              stripe_checkout_session: checkout_session.as_json,
              email: checkout_session.customer_details.email,
              name: checkout_session.customer_details.name,
              amount: checkout_session.amount_total / 100.to_d

      tickets.create!(pending_tickets.map do |ticket|
        total_discount = checkout_session.total_details.amount_discount / 100.to_d
        individual_discount = total_discount / pending_tickets.size

        ticket["price"] = ticket["price"].to_d - individual_discount
        ticket
      end)

      Invoice.issue self if issue_invoice?
    end

    tickets.each { TicketMailer.welcome_email(it).deliver_later }
    OrderMailer.invoice_email(self).deliver_later if issue_invoice?
    NotificationMailer.sale_email(self).deliver_later
  end

  def refund!(refunded_amount:, invoice_sequence: nil)
    precondition !refunded?, "Order already refunded"

    issue_credit_note = invoice && invoice_sequence

    transaction do
      update!(refunded_amount:)

      if issue_credit_note
        Invoice.create!(
          invoice_sequence:,
          number: invoice_sequence.next_invoice_number,
          refunded_invoice: invoice,
          issue_date: Date.current,
          tax_event_date: Date.current,
          customer_name: name,
          receiver_email: email,
          customer_address:,
          customer_country:,
          customer_vat_idx:,
          items_attributes: [
            {
              description_en: "Refund for Invoice ##{invoice.number}",
              description_bg: "Възстановяване за фактура ##{invoice.number}",
              unit_price: refunded_amount,
            },
          ],
        )
      end
    end

    OrderMailer.refund_email(reload).deliver_later if issue_credit_note
  end
end
