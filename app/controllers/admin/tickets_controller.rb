class Admin::TicketsController < Admin::ApplicationController
  def index
    @filter = params[:filter]
    @tickets = scope filtered_tickets.includes(:event, :ticket_type, :checkin)
  end

  def giveaway
    tickets = giveaway_params[:tickets]
    reason = giveaway_params[:reason].presence || "Giveaway"

    Giveaway.create_free_tickets(event, tickets, reason:)

    redirect_to admin_event_tickets_path(event), notice: "#{tickets.size} free tickets created successfully"
  end

  def email
    ticket = event.tickets.find params[:id]
    TicketMailer.ticket_email(ticket).deliver_now

    redirect_to request.path, notice: "Email sent to #{ticket.email}"
  end

  private

  def filtered_tickets
    tickets = event.tickets
    case params[:filter]
    when "expected" then tickets.where.missing(:checkin)
    else tickets
    end
  end

  def giveaway_params = params.require(:giveaway).permit(:reason, tickets: [:name, :email, :shirt_size])

  def event = Event.find params[:event_id]
end
