class Admin::MediaGalleriesController < Admin::ApplicationController
  def show
    @media_gallery = event.media_gallery
  end

  def new
    @media_gallery = event.build_media_gallery
  end

  def create
    @media_gallery = event.create_media_gallery media_gallery_params

    if @media_gallery.valid?
      redirect_to admin_event_media_gallery_path(event), notice: "Media gallery created"
    else
      render :show
    end
  end

  def update
    @media_gallery = event.media_gallery

    if @media_gallery.update media_gallery_params
      redirect_to admin_event_media_gallery_path(event), notice: "Media gallery updated"
    else
      render :show
    end
  end

  private

  def event = Event.find params[:event_id]

  def media_gallery_params = params.require(:media_gallery).permit(:videos_url, :photos_url, :description, highlights: [])
end
