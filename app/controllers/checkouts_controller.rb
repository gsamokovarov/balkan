class CheckoutsController < ApplicationController
  invisible_captcha only: [:create]

  def index
    @ticket_types = @event.ticket_types.enabled.order :price
  end

  def show
    @ticket_type = @event.ticket_types.enabled.find params[:id]
  end

  def create
    redirect_to Checkout.create_link(checkout_params), allow_other_host: true
  end

  def checkout_params
    params.require(:checkout).permit :ticket_type_id, :invoice, tickets: [:name, :email, :shirt_size]
  end
end
