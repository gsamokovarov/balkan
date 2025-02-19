class Admin::SubscribersController < Admin::ApplicationController
  def index
    @subscribers = scope event.subscribers.order(id: :desc)
  end

  def destroy
    subscriber = Subscriber.find params[:id]
    subscriber.destroy

    redirect_to admin_event_subscribers_path(subscriber.event, page: params[:page]),
                notice: "Subscriber #{subscriber.email} was deleted"
  end

  private

  def event = Event.find params[:event_id]
end
