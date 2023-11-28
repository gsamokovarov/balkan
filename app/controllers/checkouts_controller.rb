class CheckoutsController < ApplicationController
  def create
    redirect_to Checkout.create_link(
      checkout_params,
      TicketType.enabled.find(checkout_params[:ticket_type_id])
    ), allow_other_host: true
  end

  def checkout_params
    params.require(:checkout).permit :ticket_type_id, :invoice, tickets: [:name, :email, :shirt_size]
  end
end
