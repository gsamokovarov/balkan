class TicketMailer < ApplicationMailer
  def welcome_email(ticket)
    @ticket = ticket
    @ticket_png = ticket.qrcode.as_png size: 240

    attachments.inline["inline_ticket.png"] = @ticket_png.to_s
    attachments["balkan_ruby_ticket.png"] = @ticket_png.to_s

    mail to: @ticket.email, subject: "Welcome to Balkan Ruby!"
  end

  def ticket_email(ticket)
    @ticket = ticket
    @ticket_png = ticket.qrcode.as_png size: 240

    attachments.inline["inline_ticket.png"] = @ticket_png.to_s
    attachments["balkan_ruby_ticket.png"] = @ticket_png.to_s

    mail to: @ticket.email, subject: "Your ticket for Balkan Ruby"
  end

  def pre_event_email(ticket)
    @ticket = ticket
    @ticket_png = ticket.qrcode.as_png size: 240

    attachments.inline["inline_ticket.png"] = @ticket_png.to_s
    attachments["balkan_ruby_ticket.png"] = @ticket_png.to_s

    mail to: @ticket.email, subject: "Balkan Ruby is in a few days!"
  end

  def post_event_email(ticket)
    @ticket = ticket

    mail to: @ticket.email, subject: "Balkan Ruby 2024 was a GREAT SUCCESS"
  end

  def post_event_2_email(ticket)
    @ticket = ticket

    mail to: @ticket.email, subject: "Balkan Ruby 2024 videos are still editing"
  end
end
