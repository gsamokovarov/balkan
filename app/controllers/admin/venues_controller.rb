class Admin::VenuesController < Admin::ApplicationController
  def index
    @venues = Venue.all
  end

  def show
    @venue = Venue.find params[:id]
  end

  def new
    @venue = Venue.new
  end

  def create
    @venue = Venue.new venue_params

    if @venue.save
      redirect_to admin_venues_path, notice: "Venue created"
    else
      render :new
    end
  end

  def edit
    @venue = Venue.find params[:id]
  end

  def update
    @venue = Venue.find params[:id]

    if @venue.update venue_params
      redirect_to admin_venues_path, notice: "Venue updated"
    else
      render :show
    end
  end

  private

  def venue_params
    params.require(:venue).permit(:name, :description, :url, :address, :directions, :place_id,
                                  gallery_images: [], additional_images: [])
  end
end
