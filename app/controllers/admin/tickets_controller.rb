class Admin::TicketsController < Admin::ApplicationController
  def index
    @tickets = Current.event.tickets.includes(:ticket_type).order("tickets.id DESC").page(params[:page])
  end
end
