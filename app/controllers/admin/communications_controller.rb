class Admin::CommunicationsController < Admin::ApplicationController
  def index
    @communications = scope event.communications.includes(:draft).order(created_at: :desc)
  end

  def show
    @communication = event.communications.find params[:id]
    @recipients = @communication.recipients.page params[:page]
  end

  def new
    @draft = event.communication_drafts.find params[:draft_id]
    @communication = @draft.communications.new
  end

  def create
    @draft = event.communication_drafts.find params[:communication][:communication_draft_id]
    @communication = @draft.communications.new communication_params

    @draft.deliver @communication

    redirect_to admin_event_communications_path(event), notice: "Communication sent to #{@communication.recipients.count} recipients"
  end

  private

  def communication_params
    params.require(:communication).permit(:to_speakers, :to_subscribers, :to_event,
                                          recipients_attributes: [:id, :email])
  end

  def event = @event ||= Event.find(params[:event_id])
end
