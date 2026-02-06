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

  def accept
    proposal = event.proposals.find params[:id]
    proposal.accepted!

    redirect_to admin_event_proposals_path, notice: "Proposal ##{proposal.id} accepted"
  end

  def decline
    proposal = event.proposals.find params[:id]
    proposal.declined!

    redirect_to admin_event_proposals_path, notice: "Proposal ##{proposal.id} declined"
  end

  def like
    proposal = event.proposals.find params[:id]
    proposal.update! liked: !proposal.liked?

    redirect_to admin_event_proposals_path
  end

  private

  def proposal_params = params.require(:proposal).permit(:name, :email, :bio, :social_url, :title, :description, :status, :liked)
  def event = Event.find(params[:event_id])
end
