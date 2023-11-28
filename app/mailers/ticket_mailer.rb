class TicketMailer < ApplicationMailer
  def welcome_email(ticket)
    @ticket = ticket

    mail to: @ticket.email, subject: "Welcome to Balkan Ruby!"
  end
end
