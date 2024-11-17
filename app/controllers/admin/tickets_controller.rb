class Admin::TicketsController < Admin::ApplicationController
  def index
    @tickets = Current.event.tickets.includes(:ticket_type).order("created_at DESC")
  end
end
