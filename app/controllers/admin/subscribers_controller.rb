class Admin::SubscribersController < Admin::ApplicationController
  def index
    @subscribers = event.subscribers.order(id: :desc).page params[:page]
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
