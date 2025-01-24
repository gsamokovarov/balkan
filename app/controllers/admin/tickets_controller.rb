class Admin::TicketsController < Admin::ApplicationController
  def index
    @tickets = event.tickets.includes(:ticket_type).order("tickets.id DESC").page(params[:page])
  end

  private

  def event = Event.find params[:event_id]
end
