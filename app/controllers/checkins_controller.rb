class CheckinsController < ApplicationController
  include Authentication

  def create
    ticket = Ticket.find_by_token_for! :event_access, params[:ticket_id]
    ticket.create_checkin! event: ticket.event

    redirect_to ticket_path(params[:ticket_id])
  end
end
