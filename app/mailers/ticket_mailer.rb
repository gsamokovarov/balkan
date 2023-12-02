class TicketMailer < ApplicationMailer
  def welcome_email(ticket)
    @ticket = ticket
    @ticket_png = ticket.qrcode.as_png size: 240

    attachments["balkan_ruby_ticket.png"] = @ticket_png.to_s

    mail to: @ticket.email, subject: "Welcome to Balkan Ruby!"
  end

  def ticket_email(ticket)
    @ticket = ticket
    @ticket_png = ticket.qrcode.as_png size: 240

    attachments["balkan_ruby_ticket.png"] = @ticket_png.to_s

    mail to: @ticket.email, subject: "Your ticket for Balkan Ruby"
  end
end
