class ProposalsController < ApplicationController
  def new
    @proposal = Current.event.proposals.new
  end

  def create
    if HCaptcha.valid? params
      @proposal = Current.event.proposals.create proposal_params
    else
      redirect_back_or_to root_path, alert: "Verify you're not a robot"
    end
  end

  private

  def proposal_params = params.require(:proposal).permit(:name, :email, :bio, :social_url, :title, :description)
end
