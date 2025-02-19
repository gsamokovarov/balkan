class Admin::SponsorshipPackagesController < Admin::ApplicationController
  def index
    @sponsorship_packages = scope event.sponsorship_packages.includes(:variants)
  end

  def show
    @sponsorship_package = event.sponsorship_packages.find params[:id]
  end

  def new
    @sponsorship_package = event.sponsorship_packages.new
  end

  def create
    @sponsorship_package = event.sponsorship_packages.new(**sponsorship_package_params)

    if @sponsorship_package.save
      redirect_to admin_event_sponsorship_packages_path, notice: "Sponsorship package created"
    else
      render :new
    end
  end

  def edit
    @sponsorship_package = event.sponsorship_packages.find params[:id]
  end

  def update
    @sponsorship_package = event.sponsorship_packages.find params[:id]

    if @sponsorship_package.update sponsorship_package_params
      redirect_to admin_event_sponsorship_packages_path, notice: "Sponsorship package updated"
    else
      render :edit
    end
  end

  private

  def event = Event.find(params[:event_id])

  def sponsorship_package_params
    params.require(:sponsorship_package).permit(:name, :description, :event_id,
                                                variants_attributes: [[:id, :name, :price, :perks, :quantity]])
  end
end
