class TicketsController < ApplicationController
  rescue_from ActiveSupport::MessageVerifier::InvalidSignature, with: :not_found

  def show
    @ticket = Ticket.find_by_token_for! :event_access, params[:id]
  end

  private

  def not_found
    render "not_found", status: :not_found
  end
end
