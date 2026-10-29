class Admin::EventNotesController < Admin::ApplicationController
  def index
    @event_notes = scope EventNote.where(event:)
  end

  def show
    @event_note = EventNote.find params[:id]
  end

  def new
    @event_note = EventNote.new event:
  end

  def create
    @event_note = EventNote.new(**event_note_params, event:)

    if @event_note.save
      redirect_to admin_event_event_notes_path(event), notice: "Note created"
    else
      render :new
    end
  end

  def edit
    @event_note = EventNote.find params[:id]
  end

  def update
    @event_note = EventNote.find params[:id]

    if @event_note.update event_note_params
      redirect_to admin_event_event_notes_path(event), notice: "Note updated"
    else
      render :edit
    end
  end

  private

  def event_note_params = params.require(:event_note).permit(:event_id, :name, :description, :url)
  def event = Event.find(params[:event_id])
end
