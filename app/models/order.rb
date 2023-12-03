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

      tickets.create!(tickets_metadata.map do |data|
        total_discount = (checkout_session.total_details.amount_discount || 0) / 100.to_d
        individual_discount = total_discount / tickets_metadata.size

        data["price"] = data["price"].to_d - individual_discount
        data
      end)
    end

    tickets.each do
      TicketMailer.welcome_email(_1).deliver_now
      TicketMailer.ticket_email(_1).deliver_now
    end
  end
end
