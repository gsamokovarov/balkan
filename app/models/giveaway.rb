module Giveaway
  extend self

  def create_free_tickets(event, tickets, reason: "Giveaway")
    tickets =
      ApplicationRecord.transaction do
        ticket_type = event.ticket_types.find_by! name: "Free", enabled: false, price: 0

        name, email = tickets.first.values_at :name, :email

        order = Order.create! event:, name:, email:, free: true, free_reason: reason, completed_at: Time.current
        order.tickets.create!(tickets.map { { **it, ticket_type:, price: 0 } })
      end

    tickets.each { TicketMailer.welcome_email(it).deliver_later }
    tickets
  end
end
