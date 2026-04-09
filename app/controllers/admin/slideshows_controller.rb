class Admin::SlideshowsController < Admin::ApplicationController
  def show
    @slideshow = event.slideshow
  end

  def new
    @slideshow = event.build_slideshow content: ""
  end

  def create
    @slideshow = event.create_slideshow slideshow_params

    if @slideshow.valid?
      redirect_to admin_event_slideshow_path(event), notice: "Slideshow created"
    else
      render :new
    end
  end

  def update
    @slideshow = event.slideshow

    if @slideshow.update slideshow_params
      redirect_to admin_event_slideshow_path(event), notice: "Slideshow updated"
    else
      render :show
    end
  end

  private

  def event = Event.find(params[:event_id])

  def slideshow_params
    params.require(:slideshow).permit(:content)
  end
end
