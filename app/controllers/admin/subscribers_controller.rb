class Admin::SubscribersController < Admin::ApplicationController
  def index
    @subscribers = scope Subscriber.order(id: :desc)
  end

  def destroy
    subscriber = Subscriber.find params[:id]
    subscriber.destroy

    redirect_to admin_event_subscribers_path(params[:event_id], page: params[:page]),
                notice: "Subscriber #{subscriber.email} was deleted"
  end
end
