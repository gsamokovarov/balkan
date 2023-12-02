class Order < ApplicationRecord
  belongs_to :event
  has_many :tickets

  def expire!(checkout_session)
    update! expired_at: Time.current,
            stripe_checkout_session: checkout_session.to_h
  end

  def complete!(checkout_session)
    update! completed_at: Time.current,
            email: checkout_session.customer_details.email,
            stripe_checkout_session: checkout_session.to_h

    tickets.create! apply_promo_code_discount(tickets_metadata, checkout_session.to_h)

    tickets.each do
      TicketMailer.welcome_email(_1).deliver_now
      TicketMailer.ticket_email(_1).deliver_now
    end
  end

  private

  def apply_promo_code_discount(tickets_meta, checkout_session)
    return tickets_meta unless checkout_session["allow_promotion_codes"]

    discount = checkout_session.dig("total_details", "amount_discount").presence || 0

    return tickets_meta if discount.zero?

    ticket_discount = (BigDecimal(discount) / 100) / tickets_meta.size

    tickets_meta.map { _1.merge("price" => BigDecimal(_1["price"]) - ticket_discount)}
  end
end
