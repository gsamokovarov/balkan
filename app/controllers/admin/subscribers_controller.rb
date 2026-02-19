class Admin::SubscribersController < Admin::ApplicationController
  def index
    @subscribers = scope Subscriber.order(id: :desc)
  end

  def destroy
    subscriber = Subscriber.find params[:id]
    subscriber.destroy

    redirect_to admin_subscribers_path(page: params[:page]),
                notice: "Subscriber #{subscriber.email} was deleted"
  end
end
