# Preview all emails at http://localhost:3000/rails/mailers/ticket
class TicketPreview < ActionMailer::Preview
  def welcome_email
    ticket = Ticket.new(name: "John Doe", email: "genadi+test@hey.com")

    TicketMailer.welcome_email(ticket).deliver_now
  end
end
