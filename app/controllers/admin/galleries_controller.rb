class Admin::GalleriesController < Admin::ApplicationController
  def show
    @gallery = event.gallery
  end

  def new
    @gallery = event.build_gallery
  end

  def create
    @gallery = event.create_gallery gallery_params

    if @gallery.valid?
      redirect_to admin_event_gallery_path(event), notice: "Gallery created"
    else
      render :show
    end
  end

  def update
    @gallery = event.gallery

    if @gallery.update gallery_params
      redirect_to admin_event_gallery_path(event), notice: "Gallery updated"
    else
      render :show
    end
  end

  private

  def event = Event.find params[:event_id]

  def gallery_params = params.require(:gallery).permit(:videos_url, :photos_url, :description, highlights: [])
end
