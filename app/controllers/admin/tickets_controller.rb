class Admin::TicketsController < Admin::ApplicationController
  allow_staff_to :checkin

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

  def checkin
    ticket = event.tickets.find params[:id]
    ticket.create_checkin!(event:)

    redirect_back_or_to ticket.event_access_url
  end

  private

  def filtered_tickets
    tickets = event.tickets
    tickets = tickets.where.missing(:checkin) if params[:filter] == "expected"
    tickets = tickets.where(ticket_type_id: params[:ticket_type_id]) if params[:ticket_type_id].present?
    tickets
  end

  def giveaway_params = params.require(:giveaway).permit(:reason, tickets: [:name, :email, :shirt_size])

  def event = Event.find params[:event_id]
end
