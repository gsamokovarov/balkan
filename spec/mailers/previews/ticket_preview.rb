require "factory_bot_rails"

# Preview all emails at http://localhost:3000/rails/mailers/ticket
class TicketPreview < ActionMailer::Preview
  include FactoryBot::Syntax::Methods

  def welcome_email
    ticket = build :ticket, name: "Genadi Samokovarov"
    ticket.event = ticket.order.event

    TicketMailer.welcome_email(ticket).deliver_now
  end

  def ticket_email
    ticket = build :ticket, name: "Genadi Samokovarov"
    ticket.event = ticket.order.event

    TicketMailer.ticket_email(ticket).deliver_now
  end

  def pre_event_email
    ticket = build :ticket, name: "Genadi Samokovarov"
    ticket.event = ticket.order.event

    TicketMailer.pre_event_email(ticket).deliver_now
  end
end
