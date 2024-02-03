module Giveaway
  extend self

  def create_free_ticket(event, name:, email:, shirt_size:, reason: "Giveaway")
    ApplicationRecord.transaction do
      ticket_type = event.ticket_types.find_by! enabled: false, price: 0
      precondition ticket_type.name == "Free"

      order = Order.create! event:, name:, email:, free: true, free_reason: reason, completed_at: Time.current
      ticket = order.tickets.create! name:, email:, shirt_size:, ticket_type:, price: 0

      TicketMailer.welcome_email(ticket).deliver_later

      ticket
    end
  end
end
