class Admin::NotificationsController < Admin::ApplicationController
  def index
    @notifications = scope event.notifications
  end

  def show
    @notification = event.notifications.find params[:id]
  end

  def new
    @notification = event.notifications.new
  end

  def create
    @notification = event.notifications.new notification_params

    if @notification.save
      redirect_to admin_event_notifications_path, notice: "Notification created"
    else
      render :new
    end
  end

  def edit
    @notification = event.notifications.find params[:id]
  end

  def update
    @notification = event.notifications.find params[:id]

    if @notification.update notification_params
      redirect_to admin_event_notifications_path, notice: "Notification updated"
    else
      render :show
    end
  end

  def activate
    notification = event.notifications.find params[:id]
    Notification.activate notification

    redirect_to admin_event_notifications_path, notice: "Notification ##{notification.id} activated"
  end

  def deactivate
    Notification.deactivate event

    redirect_to admin_event_notifications_path, notice: "Notification deactivated"
  end

  private

  def notification_params = params.require(:notification).permit(:message, :active)
  def event = Event.find(params[:event_id])
end
