class Admin::SpeakersController < Admin::ApplicationController
  def index
    @speakers = scope Speaker.with_attached_avatar
  end

  def show
    @speaker = Speaker.find params[:id]
  end

  def new
    @speaker = Speaker.new
  end

  def create
    @speaker = Speaker.new speaker_params

    if @speaker.save
      redirect_to admin_speakers_path, notice: "Speaker created"
    else
      render :new
    end
  end

  def edit
    @speaker = Speaker.find params[:id]

    render :show
  end

  def update
    @speaker = Speaker.find params[:id]

    if @speaker.update speaker_params
      redirect_to admin_speakers_path, notice: "Speaker updated"
    else
      render :show
    end
  end

  private def speaker_params = params.require(:speaker).permit(:name, :bio, :github_url, :social_url, :avatar)
end
