# Preview all emails at http://localhost:3000/rails/mailers/ticket
class TicketPreview < ActionMailer::Preview
  def welcome_email
    ticket = Ticket.new name: "John Doe",
                        email: "genadi+test@hey.com",
                        order: Order.new(completed_at: Time.current)

    TicketMailer.welcome_email(ticket).deliver_now
  end
end
