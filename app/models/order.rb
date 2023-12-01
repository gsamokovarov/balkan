class Order < ApplicationRecord
  belongs_to :event
  has_many :tickets

  def expire!(checkout_session)
    update! expired_at: Time.current,
            stripe_checkout_session: checkout_session.to_h

    tickets.destroy_all
  end

  def complete!(checkout_session)
    update! completed_at: Time.current,
            email: checkout_session.customer_details.email,
            stripe_checkout_session: checkout_session.to_h

    tickets.create! tickets_metadata
    tickets.each do
      TicketMailer.welcome_email(_1).deliver_now
    end
  end
end
