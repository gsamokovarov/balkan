class SubscribersController < ApplicationController
  def show
    @subscriber = Subscriber.find_by_token_for! :cancelation, params[:id]
  end

  def create
    if HCaptcha.valid? params
      @subscriber = Subscriber.create subscriber_params
      SubscriberMailer.welcome_email(@subscriber).deliver_later if @subscriber.valid?
    else
      redirect_back_or_to root_path, alert: "Verify you're not a robot"
    end
  end

  def destroy
    @subscriber = Subscriber.find_by_token_for! :cancelation, params[:id]
    @subscriber.destroy!
  end

  private

  def subscriber_params = params.require(:subscriber).permit(:email)
end
