namespace :tickets do
  desc "Set the enabled ticket type to all tickets without one"
  task set_ticket_type: :environment do
    ticket_type = TicketType.enabled.last

    Ticket.where(ticket_type: nil).update_all(ticket_type_id: ticket_type.id)
  end
end
