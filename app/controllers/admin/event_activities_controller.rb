class Admin::EventActivitiesController < Admin::ApplicationController
  def show
    @event_activity = event.event_activity || event.build_event_activity
  end

  def create
    @event_activity = event.build_event_activity(**event_activity_params)

    if @event_activity.save
      redirect_to admin_event_event_activity_path(event), notice: "Activity created"
    else
      render :show
    end
  end

  def update
    @event_activity = event.event_activity

    if @event_activity.update event_activity_params
      redirect_to admin_event_event_activity_path(event), notice: "Activity updated"
    else
      render :show
    end
  end

  private

  def event_activity_params
    params.require(:event_activity).permit :event_id, :content, :published, images: []
  end

  def event = Event.find(params[:event_id])
end
