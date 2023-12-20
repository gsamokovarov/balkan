class SubscribersController < ApplicationController
  def create
    @subscriber = Subscriber.create subscriber_params

    render :create, status: :created
  end

  def destroy
    @subscriber = Subscriber.find_by_token_for! :cancelation, params[:id]
    @subscriber.destroy!

    render :destroy
  end

  private

  def subscriber_params
    params.require(:subscriber).permit(:event_id, :email)
  end
end
