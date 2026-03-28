class JobsController < ApplicationController
  def index
    @job_postings = Current.event.job_postings.published.includes :sponsor
  end

  def show
    @job_posting = Current.event.job_postings.find params[:id]
  end

  def update
    @job_posting = Current.event.job_postings.find params[:id]

    if HCaptcha.valid? params
      render :update
    else
      redirect_to job_path(@job_posting), alert: "Verify you're not a robot"
    end
  end
end
