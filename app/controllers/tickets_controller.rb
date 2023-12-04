class TicketsController < ApplicationController
  def show
    @ticket = Ticket.find_by_token_for! :event_access, params[:id]
  end
end
