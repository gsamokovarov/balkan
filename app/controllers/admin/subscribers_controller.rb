class Admin::SubscribersController < Admin::ApplicationController
  def index
    @subscribers = Subscriber.for(Event.find(params[:event_id])).page(params[:page])
  end
end
