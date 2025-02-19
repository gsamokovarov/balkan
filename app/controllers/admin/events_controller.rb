class Admin::EventsController < Admin::ApplicationController
  def index
    @events = scope Event.all
  end

  def show
    @event = Event.find params[:id]
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(**event_params)

    if @event.save
      redirect_to admin_events_path, notice: "Event created"
    else
      console
      render :new
    end
  end

  def edit
    @event = Event.find params[:id]
  end

  def update
    @event = Event.find params[:id]

    if @event.update event_params
      redirect_to admin_events_path, notice: "Event updated"
    else
      render :show
    end
  end

  private

  def event_params
    params.require(:event).permit(:name, :host, :start_date, :end_date, :venue_id, :title, :subtitle, :contact_email,
                                  :description, :speaker_applications_end_date, :speaker_applications_url, :twitter_url,
                                  :facebook_url, :youtube_url, :invoice_sequence_id, :logo, hero_images: [])
  end
end
