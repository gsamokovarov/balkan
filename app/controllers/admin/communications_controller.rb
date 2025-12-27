class Admin::CommunicationsController < Admin::ApplicationController
  def index
    @communications = scope event.communications.includes(:communication_draft).order(created_at: :desc)
  end

  def show
    @communication = event.communications.find params[:id]
  end

  def new
    @draft = event.communication_drafts.find params[:draft_id]
    @communication = @draft.communications.new
  end

  def create
    @draft = event.communication_drafts.find communication_params[:communication_draft_id]
    @communication = @draft.communications.new communication_params

    @draft.deliver @communication

    redirect_to admin_event_communications_path(event), notice: "Communication sent to #{@communication.recipient_count} recipients"
  end

  private

  def communication_params
    params.require(:communication).permit(:communication_draft_id, :to_speakers, :to_subscribers, :to_event)
  end

  def event = @event ||= Event.find(params[:event_id])
end
