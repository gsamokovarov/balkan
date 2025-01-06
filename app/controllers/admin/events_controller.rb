class Admin::EventsController < Admin::ApplicationController
  def index
    @events = Event.all
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
    params.require(:event).permit(
      :invoice_sequence_id, :name, :host, :start_date, :end_date, :speaker_applications_end_date
    )
  end
end
