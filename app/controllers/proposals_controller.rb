class ProposalsController < ApplicationController
  def new
    @proposal = Current.event.proposals.new
  end

  def create
    precondition Current.event.accepts_speaking_applications?

    unless HCaptcha.valid? params
      return redirect_back_or_to root_path, alert: "Verify you're not a robot"
    end

    @proposal = Current.event.proposals.new proposal_params

    if @proposal.save
      ProposalMailer.submitted(@proposal).deliver_later
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @proposal = Proposal.find_by_token_for! :access, params[:id]
  end

  def update
    @proposal = Proposal.find_by_token_for! :access, params[:id]

    unless @proposal.update proposal_params
      render :show, status: :unprocessable_entity
    end
  end

  private

  def proposal_params = params.require(:proposal).permit(:name, :email, :bio, :company, :location, :social_url, :github_url, :title, :description, :notes)
end
