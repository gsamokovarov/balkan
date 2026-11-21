class TicketMailer < ApplicationMailer
  def welcome_email(ticket)
    @ticket = ticket
    @ticket_png = ticket.qrcode.as_png size: 240

    attachments.inline["inline_ticket.png"] = @ticket_png.to_s
    attachments["ticket.png"] = @ticket_png.to_s

    mail to: @ticket.email, subject: "Welcome to #{ticket.event.name}"
  end

  def ticket_email(ticket)
    @ticket = ticket
    @ticket_png = ticket.qrcode.as_png size: 240

    attachments.inline["inline_ticket.png"] = @ticket_png.to_s
    attachments["ticket.png"] = @ticket_png.to_s

    mail to: @ticket.email, subject: "Your ticket for #{ticket.event.name}"
  end
end
