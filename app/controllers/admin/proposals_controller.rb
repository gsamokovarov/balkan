class Admin::ProposalsController < Admin::ApplicationController
  def index
    @filter = params[:filter]
    @proposals = scope filtered_proposals
  end

  def show
    @proposal = event.proposals.find params[:id]
    @filter = params[:filter]
    @workingset = Admin::Workingset.for @proposal, in: filtered_proposals.order(id: :desc)
  end

  def update
    @proposal = event.proposals.find params[:id]
    @filter = params[:filter]

    if @proposal.update proposal_params
      redirect_to admin_event_proposals_path, notice: "Proposal updated"
    else
      @workingset = Admin::Workingset.for @proposal, in: filtered_proposals.order(id: :desc)
      render :show
    end
  end

  def accept
    proposal = event.proposals.find params[:id]
    proposal.accepted!

    redirect_to request.path, notice: "Proposal ##{proposal.id} accepted"
  end

  def decline
    proposal = event.proposals.find params[:id]
    proposal.declined!

    redirect_to request.path, notice: "Proposal ##{proposal.id} declined"
  end

  def like
    proposal = event.proposals.find params[:id]
    proposal.update! liked: !proposal.liked?

    redirect_to request.path, notice: "Proposal #{proposal.id} starred"
  end

  def select
    proposals = event.proposals.accepted.where notified_at: nil

    proposals.each do |proposal|
      ProposalMailer.selected(proposal).deliver_later
      proposal.update! notified_at: Time.current
    end

    redirect_to admin_event_proposals_path(filter: :accepted), notice: "Selected #{proposals.size} proposals"
  end

  def waitlist
    proposals = event.proposals.pending.where notified_at: nil

    proposals.each do |proposal|
      ProposalMailer.waitlisted(proposal).deliver_later
      proposal.update! notified_at: Time.current
    end

    redirect_to admin_event_proposals_path(filter: :pending), notice: "Waitlisted #{proposals.size} proposals"
  end

  def import
    count = Proposal::Importer.import event, params[:file].read

    redirect_to admin_event_proposals_path, notice: "Imported #{count} proposals"
  end

  private

  def filtered_proposals
    proposals = event.proposals
    case params[:filter]
    when "starred"  then proposals.where(liked: true)
    when "accepted" then proposals.accepted
    when "pending"  then proposals.pending
    when "declined" then proposals.declined
    else proposals
    end
  end

  def proposal_params = params.require(:proposal).permit(:name, :email, :bio, :company, :location, :social_url, :github_url, :title, :description, :notes, :status, :liked)
  def event = Event.find(params[:event_id])
end
