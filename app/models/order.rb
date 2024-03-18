class Order < ApplicationRecord
  INVOICING_START_DATE = Date.new 2024, 2, 3

  belongs_to :event
  has_many :tickets
  has_one :invoice_sequence, through: :event
  has_one :invoice

  def self.completed = where("completed_at IS NOT NULL")

  def stripe_object = stripe_checkout_session && Stripe::Checkout::Session.construct_from(stripe_checkout_session)

  def refunded? = refunded_amount.positive?
  def fully_refunded? = refunded? && refunded_amount == amount

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

    tickets.each { TicketMailer.welcome_email(_1).deliver_later }
    OrderMailer.invoice_email(self).deliver_later if issue_invoice?
  end

  def invoicable?
    issue_invoice? && completed_at.after?(INVOICING_START_DATE)
  end
end
