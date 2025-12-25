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

    if @communication.save
      # Build recipients from filters
      @communication.build_recipients_from_filters if @communication.has_filter_changes?
      @communication.save

      # Send immediately
      @communication.deliver!

      # Mark draft as sent
      @communication.communication_draft.update(sent_at: Time.current)

      redirect_to admin_event_communications_path(event), notice: "Communication sent to #{@communication.recipient_count} recipients"
    else
      @draft = @communication.communication_draft
      render :new
    end
  rescue => e
    redirect_to admin_event_communications_path(event), alert: "Failed to send: #{e.message}"
  end

  def preview
    @communication = event.communications.find(params[:id])
    @sample_email = params[:sample_email] || "preview@example.com"
    @rendered = @communication.render_for(@sample_email)

    render layout: false
  end

  private

  def communication_params
    params.require(:communication).permit(
      :communication_draft_id,
      :include_subscribers,
      :include_ticket_holders,
      :include_speakers,
      :custom_recipients_text,
      event_ids: []
    )
  end

  def event
    @event ||= Event.find(params[:event_id])
  end
end
