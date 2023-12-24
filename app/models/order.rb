class Order < ApplicationRecord
  STRIPE_FEE = "2.50".to_d
  BULGARIAN_VAT = "0.2".to_d

  belongs_to :event
  has_many :tickets

  def gross_amount = amount - refunded_amount
  def net_amount = gross_amount - tax_amount
  def tax_amount = (amount * BULGARIAN_VAT) + 2.50

  def refunded? = refunded_amount.positive?
  def fully_refunded? = refunded_amount == amount

  def expire!(checkout_session)
    update! expired_at: Time.current,
            stripe_checkout_session: checkout_session.as_json
  end

  def complete!(checkout_session)
    transaction do
      update! completed_at: Time.current,
              stripe_checkout_session: checkout_session.as_json,
              email: checkout_session.customer_details.email,
              amount: checkout_session.amount_total / 100.to_d

      tickets.create!(pending_tickets.map do |ticket|
        total_discount = checkout_session.total_details.amount_discount / 100.to_d
        individual_discount = total_discount / pending_tickets.size

        ticket["price"] = ticket["price"].to_d - individual_discount
        ticket
      end)
    end

    tickets.each do
      TicketMailer.welcome_email(_1).deliver_later
    end
  end
end
