class Admin::SubscribersController < Admin::ApplicationController
  def index
    @subscribers = Subscriber.for(Event.find(params[:event_id])).page(params[:page])
  end

  def destroy
    subscriber = Subscriber.find params[:id]
    subscriber.destroy

    redirect_to admin_event_subscribers_path(subscriber.event), notice: "Subscriber #{subscriber.email} was deleted"
  end
end
