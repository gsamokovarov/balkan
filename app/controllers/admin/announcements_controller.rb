class Admin::AnnouncementsController < Admin::ApplicationController
  def index
    @announcements = scope event.announcements
  end

  def show
    @announcement = event.announcements.find params[:id]
  end

  def new
    @announcement = event.announcements.new
  end

  def create
    @announcement = event.announcements.new announcement_params

    if @announcement.save
      redirect_to admin_event_announcements_path, notice: "Announcement created"
    else
      render :new
    end
  end

  def edit
    @announcement = event.announcements.find params[:id]
  end

  def update
    @announcement = event.announcements.find params[:id]

    if @announcement.update announcement_params
      redirect_to admin_event_announcements_path, notice: "Announcement updated"
    else
      render :show
    end
  end

  def activate
    announcement = event.announcements.find params[:id]
    Announcement.activate announcement

    redirect_to admin_event_announcements_path, notice: "Announcement ##{announcement.id} activated"
  end

  def deactivate
    Announcement.deactivate event

    redirect_to admin_event_announcements_path, notice: "Announcement deactivated"
  end

  private

  def announcement_params = params.require(:announcement).permit(:message, :active)
  def event = Event.find(params[:event_id])
end
