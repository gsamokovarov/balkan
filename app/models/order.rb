class Order < ApplicationRecord
  belongs_to :event
  has_many :tickets

  def expire!(checkout_session)
    update! expired_at: Time.current,
            stripe_checkout_session: checkout_session.as_json
  end

  def complete!(checkout_session)
    transaction do
      update! completed_at: Time.current,
              stripe_checkout_session: checkout_session.as_json,
              email: checkout_session.customer_details.email

      tickets.create!(pending_tickets.map do |ticket|
        total_discount = checkout_session.total_details.amount_discount / 100.to_d
        individual_discount = total_discount / pending_tickets.size

        ticket["price"] = ticket["price"].to_d - individual_discount
        ticket
      end)
    end

    tickets.each do
      TicketMailer.welcome_email(_1).deliver_now
    end
  end
end
