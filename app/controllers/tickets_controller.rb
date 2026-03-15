class TicketsController < ApplicationController
  rescue_from ActiveSupport::MessageVerifier::InvalidSignature, with: :not_found

  def show
    @ticket = Ticket.find_by_token_for! :event_access, params[:id]
  end

  def wallet_pass
    @ticket = Ticket.find_by_token_for! :event_access, params[:id]
    pass = WalletPass.new(@ticket)
    send_data pass.to_pkpass, type: pass.content_type, filename: pass.filename, disposition: :attachment
  end

  private

  def not_found
    render "not_found", status: :not_found
  end
end
