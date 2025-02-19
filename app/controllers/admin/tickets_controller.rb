class Admin::TicketsController < Admin::ApplicationController
  def index
    @tickets = scope event.tickets.includes(:ticket_type)
  end

  private

  def event = Event.find params[:event_id]
end
