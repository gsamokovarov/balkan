class Admin::CommunicationsController < Admin::ApplicationController
  def index
    @communications = scope event.communications.includes(:communication_draft).order(created_at: :desc)
  end

  def show
    @communication = event.communications.find(params[:id])
  end

  def new
    @communication = event.communications.new
    @draft = CommunicationDraft.find(params[:draft_id]) if params[:draft_id]
    @communication.communication_draft = @draft if @draft
  end

  def create
    @communication = event.communications.new(communication_params)
    @draft = @communication.communication_draft

    @draft.send(@communication)

    # Mark draft as sent
    @draft.update(sent_at: Time.current)

    redirect_to admin_event_communications_path(event), notice: "Communication sent to #{@communication.recipient_count} recipients"
  rescue => e
    render :new
  end

  private

  def communication_params
    params.require(:communication).permit(
      :communication_draft_id,
      :to_speakers,
      :to_subscribers,
      :to_event
    )
  end

  def event
    @event ||= Event.find(params[:event_id])
  end
end
