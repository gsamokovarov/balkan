class CheckoutsController < ApplicationController
  def index
    @ticket_types = TicketType.all
  end

  def show
    @ticket_type = TicketType.enabled.find(params[:id].to_i)
  end

  def create
    ticket_type = TicketType.enabled.find checkout_params[:ticket_type_id]

    redirect_to Checkout.create_link(checkout_params, ticket_type), allow_other_host: true
  end

  def checkout_params
    params.require(:checkout).permit :ticket_type_id, :invoice, tickets: [:name, :email, :shirt_size]
  end
end
