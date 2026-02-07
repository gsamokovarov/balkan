class ProposalsController < ApplicationController
  def new
    @proposal = Current.event.proposals.new
  end

  def create
    if HCaptcha.valid? params
      @proposal = Current.event.proposals.create proposal_params
      ProposalMailer.submitted(@proposal).deliver_later if @proposal.persisted?
    else
      redirect_back_or_to root_path, alert: "Verify you're not a robot"
    end
  end

  def show
    @proposal = Proposal.find_by_token_for! :access, params[:id]
  end

  def update
    @proposal = Proposal.find_by_token_for! :access, params[:id]

    if @proposal.update proposal_params
      redirect_to @proposal.access_url, notice: "Proposal updated"
    else
      render :show
    end
  end

  private

  def proposal_params = params.require(:proposal).permit(:name, :email, :bio, :social_url, :title, :description)
end
