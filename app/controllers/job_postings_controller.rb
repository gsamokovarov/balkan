class JobPostingsController < ApplicationController
  def index
    @job_postings = Current.event.job_postings.published.includes :sponsor
  end

  def show
    @job_posting = Current.event.job_postings.published.find params[:id]
  end
end
