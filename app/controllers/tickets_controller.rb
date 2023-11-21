class TicketsController < ApplicationController
  def index
    @ticket_types = TicketType.all
  end

  def show
    @ticket_type = TicketType.find(params[:id].to_i)
  end
end
