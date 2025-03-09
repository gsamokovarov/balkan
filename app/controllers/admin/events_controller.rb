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

  def thumbnail
    @event = Event.find params[:id]
    @selected_member_ids = Array(params[:member_ids])
    @show_details = params[:show_details] == "1"
    @grid_columns = params[:grid_columns]

    @lineup_members =
      if @selected_member_ids.any?
        @event.lineup_members.confirmed.where id: @selected_member_ids
      else
        @event.lineup_members.confirmed
      end
  end

  private

  def event_params
    params.require(:event).permit(:name, :host, :start_date, :end_date, :venue_id, :title, :subtitle, :contact_email,
                                  :description, :speaker_applications_end_date, :speaker_applications_url, :twitter_url,
                                  :facebook_url, :youtube_url, :invoice_sequence_id, :logo, :ogp_image, hero_images: [])
  end
end
