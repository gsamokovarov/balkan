class CheckoutsController < ApplicationController
  def show
    @ticket_type = Current.event.ticket_types.enabled.find params[:id]
  end

  def create
    precondition HCaptcha.valid?(params), "Invalid captcha"

    redirect_to Checkout.create_link(checkout_params), allow_other_host: true
  end

  def checkout_params
    params.require(:checkout).permit :ticket_type_id, :invoice, tickets: [:name, :email, :shirt_size]
  end
end
