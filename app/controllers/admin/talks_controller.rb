class Admin::TalksController < Admin::ApplicationController
  def index
    @talks = scope Talk.all
  end

  def show
    @talk = Talk.find params[:id]
  end

  def new
    @talk = Talk.new
  end

  def create
    @talk = Talk.new talk_params

    if @talk.save
      redirect_to admin_talks_path, notice: "Talk created"
    else
      render :new
    end
  end

  def edit
    @talk = Talk.find params[:id]
  end

  def update
    @talk = Talk.find params[:id]

    if @talk.update talk_params
      redirect_to admin_talks_path, notice: "Talk updated"
    else
      render :show
    end
  end

  private def talk_params = params.require(:talk).permit(:name, :description, :video_url, :ogp_image, speaker_ids: [])
end
