class CheckoutsController < ApplicationController
  def show
    @ticket_type = Current.event.ticket_types.enabled.find params[:id]
  end

  def create
    if HCaptcha.valid? params
      redirect_to Checkout.create_link(checkout_params), allow_other_host: true
    else
      redirect_back_or_to checkouts_path, alert: "Verify you're not a robot"
    end
  end

  def checkout_params
    params.require(:checkout).permit :ticket_type_id, :invoice, :discount_code, tickets: [:name, :email, :shirt_size]
  end
end
