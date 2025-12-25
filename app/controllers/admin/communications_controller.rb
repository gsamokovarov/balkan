class Admin::CommunicationsController < Admin::ApplicationController
  def index
    @communications = scope event.communications.includes(:communication_template).order(id: :desc)
  end

  def show
    @communication = event.communications.find(params[:id])
  end

  def new
    @communication = event.communications.new

    # Pre-fill from template if provided
    if params[:template_id]
      template = CommunicationTemplate.find(params[:template_id])
      @communication.communication_template = template
      @communication.subject = template.subject_template
      @communication.content = template.content_template
    end
  end

  def create
    @communication = event.communications.create communication_params

    if @communication.valid?
      redirect_to admin_event_communication_path(event, @communication), notice: "Communication created"
    else
      render :new
    end
  end

  def edit
    @communication = event.communications.find(params[:id])

    if @communication.sent?
      redirect_to admin_event_communication_path(event, @communication),
                  alert: "Cannot edit sent communication"
    end
  end

  def update
    @communication = event.communications.find(params[:id])

    if @communication.sent?
      redirect_to admin_event_communication_path(event, @communication),
                  alert: "Cannot update sent communication"
      return
    end

    if @communication.update(communication_params)
      redirect_to admin_event_communication_path(event, @communication), notice: "Communication updated"
    else
      render :edit
    end
  end

  def send_communication
    @communication = event.communications.find(params[:id])

    if @communication.sent?
      redirect_to admin_event_communication_path(event, @communication),
                  alert: "Communication already sent"
      return
    end

    if @communication.recipient_count.zero?
      redirect_to admin_event_communication_path(event, @communication),
                  alert: "Cannot send communication with no recipients"
      return
    end

    @communication.deliver!

    redirect_to admin_event_communication_path(event, @communication),
                notice: "Communication sent to #{@communication.recipient_count} recipients"
  rescue => e
    redirect_to admin_event_communication_path(event, @communication),
                alert: "Failed to send: #{e.message}"
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
      :subject,
      :content,
      :communication_template_id,
      :include_subscribers,
      :include_ticket_holders,
      :include_speakers,
      :custom_recipients_text,
      event_ids: [],
      communication_recipients_attributes: [:id, :email, :_destroy]
    )
  end

  def event
    @event ||= Event.find(params[:event_id])
  end
end
