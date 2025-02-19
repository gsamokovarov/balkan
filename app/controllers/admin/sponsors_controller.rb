class Admin::SponsorsController < Admin::ApplicationController
  def index
    @sponsors = scope Sponsor.with_attached_logo
  end

  def show
    @sponsor = Sponsor.find params[:id]
  end

  def new
    @sponsor = Sponsor.new
  end

  def create
    @sponsor = Sponsor.new(**sponsor_params)

    if @sponsor.save
      redirect_to admin_sponsors_path, notice: "Sponsor created"
    else
      render :new
    end
  end

  def edit
    @sponsor = Sponsor.find params[:id]
  end

  def update
    @sponsor = Sponsor.find params[:id]

    if @sponsor.update sponsor_params
      redirect_to admin_sponsors_path, notice: "Sponsor updated"
    else
      render :edit
    end
  end

  private

  def sponsor_params = params.require(:sponsor).permit(:name, :description, :url, :logo)
end
