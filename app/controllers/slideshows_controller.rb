class SlideshowsController < ApplicationController
  def index
    @slideshows = Slideshow.all
  end

  def show
    @slideshow = Slideshow.find params[:id]
  end

  def new
    @slideshow = Slideshow.new
  end

  def create
    @slideshow = Slideshow.new slideshow_params

    if @slideshow.save
      redirect_to slideshows_path, notice: "Slideshow created"
    else
      render :new
    end
  end

  def edit
    @slideshow = Slideshow.find params[:id]
  end

  def update
    @slideshow = Slideshow.find params[:id]

    if @slideshow.update slideshow_params
      redirect_to slideshows_path, notice: "Slideshow updated"
    else
      render :show
    end
  end

  private

  def slideshow_params
    params.require(:slideshow).permit(:content)
  end
end
