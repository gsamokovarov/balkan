class Admin::TicketsController < Admin::ApplicationController
  def index
    @tickets = scope event.tickets.includes(:ticket_type)
  end

  def giveaway
    tickets = giveaway_params[:tickets]
    reason = giveaway_params[:reason].presence || "Giveaway"

    Giveaway.create_free_tickets(event, tickets, reason:)

    redirect_to admin_event_tickets_path(event), notice: "#{tickets.size} free tickets created successfully"
  rescue StandardError => err
    redirect_to admin_event_tickets_path(event), alert: "Error creating tickets: #{err.message}"
  end

  private

  def giveaway_params = params.require(:giveaway).permit(:reason, tickets: [:name, :email, :shirt_size])

  def event = Event.find params[:event_id]
end
