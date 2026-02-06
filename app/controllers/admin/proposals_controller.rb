class Admin::ProposalsController < Admin::ApplicationController
  def index
    @proposals = scope event.proposals
  end

  def show
    @proposal = event.proposals.find params[:id]
  end

  def edit
    @proposal = event.proposals.find params[:id]
    render :show
  end

  def update
    @proposal = event.proposals.find params[:id]

    if @proposal.update proposal_params
      redirect_to admin_event_proposals_path, notice: "Proposal updated"
    else
      render :show
    end
  end

  private

  def proposal_params = params.require(:proposal).permit(:name, :email, :bio, :social_url, :title, :description)
  def event = Event.find(params[:event_id])
end
