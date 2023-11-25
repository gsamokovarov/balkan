class CheckoutsController < ApplicationController
  def create
    redirect_to Checkout.create_link(checkout_params, TicketType.current), allow_other_host: true
  end

  def checkout_params
    params.require(:checkout).permit :invoice, tickets: [:name, :email, :shirt_size]
  end
end
