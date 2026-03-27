class Admin::JobPostingsController < Admin::ApplicationController
  def index
    @job_postings = scope event.job_postings.includes(:sponsor)
  end

  def show
    @job_posting = event.job_postings.find params[:id]
  end

  def new
    @job_posting = event.job_postings.new
  end

  def create
    @job_posting = event.job_postings.new(**job_posting_params)

    if @job_posting.save
      redirect_to admin_event_job_postings_path, notice: "Job posting created"
    else
      render :new
    end
  end

  def update
    @job_posting = event.job_postings.find params[:id]

    if @job_posting.update job_posting_params
      redirect_to admin_event_job_postings_path, notice: "Job posting updated"
    else
      render :show
    end
  end

  private

  def event = Event.find(params[:event_id])

  def job_posting_params
    params.require(:job_posting).permit(:title, :description, :application_url, :sponsor_id, :published, images: [], contacts_attributes: [:id, :name, :email, :_destroy])
  end
end
