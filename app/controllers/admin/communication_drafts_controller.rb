class Admin::CommunicationDraftsController < Admin::ApplicationController
  def index
    @drafts = scope event.communication_drafts
  end

  def show
    @draft = event.communication_drafts.find params[:id]
  end

  def new
    @draft = event.communication_drafts.new
  end

  def create
    @draft = event.communication_drafts.create draft_params

    if @draft.valid?
      redirect_to admin_event_communication_draft_path(event, @draft), notice: "Draft created"
    else
      render :new
    end
  end

  def update
    @draft = event.communication_drafts.find params[:id]

    if @draft.update draft_params
      redirect_to admin_event_communication_draft_path(event, @draft), notice: "Draft updated"
    else
      render :show
    end
  end

  def destroy
    draft = event.communication_drafts.find params[:id]
    draft.destroy

    redirect_to admin_event_communication_drafts_path(event), notice: "Draft deleted"
  end

  def preview
    context = {
      "email" => "attendee@example.com",
      "event_name" => event.name,
      "event_start_date" => event.start_date.to_s,
      "event_end_date" => event.end_date.to_s,
      "year" => event.start_date.year.to_s,
    }

    subject = Liquid::Template.parse(params[:subject]).render(context)
    body = Liquid::Template.parse(params[:content]).render(context)

    render json: { subject:, body: }
  end

  private

  def draft_params = params.require(:communication_draft).permit(:name, :subject, :content)
  def event = @event ||= Event.find(params[:event_id])
end
