class SubscribersController < ApplicationController
  invisible_captcha only: [:create, :destroy]

  def show
    @subscriber = Subscriber.find_by_token_for! :cancelation, params[:id]
  end

  def create
    @subscriber = Subscriber.create subscriber_params
    SubscriberMailer.welcome_email(@subscriber).deliver_later if @subscriber.valid?
  end

  def destroy
    @subscriber = Subscriber.find_by_token_for! :cancelation, params[:id]
    @subscriber.destroy!
  end

  private

  def subscriber_params
    params.require(:subscriber).permit(:event_id, :email)
  end
end
