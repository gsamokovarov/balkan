class Order < ApplicationRecord
  BULGARIAN_VAT = "0.2".to_d

  belongs_to :event
  has_many :tickets
  has_one :invoice_sequence, through: :event
  has_one :invoice

  def customer_email = stripe_object&.customer_details&.email
  def customer_name = stripe_object&.customer_details&.name
  def stripe_object = stripe_checkout_session && Stripe::Checkout::Session.construct_from(stripe_checkout_session)

  def gross_amount = amount - refunded_amount
  def net_amount = gross_amount - tax_amount
  def tax_amount = free? ? 0 : (amount * BULGARIAN_VAT)

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
              name: checkout_session.customer_details.name,
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
