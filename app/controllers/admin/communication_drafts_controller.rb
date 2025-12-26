class Admin::CommunicationDraftsController < Admin::ApplicationController
  def index
    @drafts = scope CommunicationDraft.all
  end

  def show
    @draft = CommunicationDraft.find params[:id]
  end

  def new
    @draft = CommunicationDraft.new event_id: params[:event_id]
  end

  def create
    @draft = CommunicationDraft.create draft_params

    if @draft.valid?
      redirect_to admin_communication_drafts_path, notice: "Draft created"
    else
      render :new
    end
  end

  def edit
    @draft = CommunicationDraft.find params[:id]
  end

  def update
    @draft = CommunicationDraft.find params[:id]

    if @draft.update draft_params
      redirect_to admin_communication_drafts_path, notice: "Draft updated"
    else
      render :edit
    end
  end

  def destroy
    @draft = CommunicationDraft.find params[:id]
    @draft.destroy

    redirect_to admin_communication_drafts_path, notice: "Draft deleted"
  end

  def preview
    event = Event.find(params[:event_id]) if params[:event_id].present?
    draft = CommunicationDraft.new subject: params[:subject], content: params[:content], event: event

    render json: draft.preview
  end

  private

  def draft_params = params.require(:communication_draft).permit(:name, :description, :subject, :content, :event_id)
end
