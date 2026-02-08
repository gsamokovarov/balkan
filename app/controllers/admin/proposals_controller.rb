class Admin::ProposalsController < Admin::ApplicationController
  def index
    proposals = event.proposals

    case params[:filter]
    when "starred"  then proposals = proposals.where(liked: true)
    when "accepted" then proposals = proposals.accepted
    when "pending"  then proposals = proposals.pending
    when "declined" then proposals = proposals.declined
    end

    @filter = params[:filter]
    @proposals = scope proposals
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

  private

  def proposal_params = params.require(:proposal).permit(:name, :email, :bio, :company, :location, :social_url, :github_url, :title, :description, :notes, :status, :liked)
  def event = Event.find(params[:event_id])
end
