class TicketsController < ApplicationController
  include Authentication

  allow_unauthenticated_access only: :show

  rescue_from ActiveSupport::MessageVerifier::InvalidSignature, with: :not_found

  def show
    resume_session

    @ticket = Ticket.find_by_token_for! :event_access, params[:id]
  end

  private

  def not_found
    render "not_found", status: :not_found
  end
end
