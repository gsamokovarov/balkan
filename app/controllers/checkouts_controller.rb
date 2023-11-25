class CheckoutsController < ApplicationController
  # TODO: Remove when done developing or when there is a UI for the ordering.
  skip_before_action :verify_authenticity_token

  def create
    redirect_to Checkout.create_link(checkout_params, TicketType.current), allow_other_host: true
  end

  def checkout_params
    params.require(:checkout).permit :invoice, tickets: [:name, :email, :shirt_size]
  end
end
