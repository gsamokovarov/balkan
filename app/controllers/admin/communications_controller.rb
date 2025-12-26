class Admin::CommunicationsController < Admin::ApplicationController
  def index
    @communications = scope Communication.joins(:communication_draft)
      .where(communication_drafts: { event_id: event.id })
      .includes(:communication_draft)
      .order(created_at: :desc)
  end

  def show
    @communication = Communication.joins(:communication_draft)
      .where(communication_drafts: { event_id: event.id })
      .find(params[:id])
  end

  def new
    @event = event
    @draft = event.communication_drafts.find(params[:draft_id]) if params[:draft_id]
    @communication = Communication.new
    @communication.communication_draft = @draft if @draft
  end

  def create
    @communication = Communication.new communication_params
    @draft = @communication.communication_draft

    # Ensure draft belongs to this event
    unless @draft&.event_id == event.id
      redirect_to admin_event_communications_path(event), alert: "Invalid draft for this event"
      return
    end

    @draft.deliver @communication

    # Mark draft as sent
    @draft.update sent_at: Time.current

    redirect_to admin_event_communications_path(event), notice: "Communication sent to #{@communication.recipient_count} recipients"
  rescue StandardError => err
    render :new
  end

  private

  def communication_params
    params.require(:communication).permit(
      :communication_draft_id,
      :to_speakers,
      :to_subscribers,
      :to_event,
    )
  end

  def event
    @event ||= Event.find params[:event_id]
  end
end
