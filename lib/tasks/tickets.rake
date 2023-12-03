namespace :tickets do
  desc "Set the enabled ticket type to all tickets without one"
  task set_ticket_type: :environment do
    ticket_type = TicketType.enabled.last

    Ticket.where(ticket_type: nil).update_all(ticket_type_id: ticket_type.id)
  end

  desc "Cleanup tickets of expired orders"
  task delete_expired: :environment do
    Order.where.not(expired_at: nil).each { _1.tickets.destroy_all }
  end
end
