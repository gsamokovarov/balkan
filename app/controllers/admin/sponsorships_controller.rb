class Admin::SponsorshipsController < Admin::ApplicationController
  def index
    @sponsorships = scope event.sponsorships.includes(:variant, :sponsor, :event)

    respond_to do |format|
      format.html
      format.json do
        render json: @sponsorships.map {
          { variant: it.variant.name, name: it.sponsor.name, description: it.sponsor.description, url: it.sponsor.url }
        }
      end
    end
  end

  def show
    @sponsorship = event.sponsorships.find params[:id]
  end

  def new
    @sponsorship = event.sponsorships.new
  end

  def create
    @sponsorship = event.sponsorships.new(**sponsorship_params)

    if @sponsorship.save
      redirect_to admin_event_sponsorships_path, notice: "Sponsorships created"
    else
      render :new
    end
  end

  def edit
    @sponsorship = event.sponsorships.find params[:id]
  end

  def update
    @sponsorship = event.sponsorships.find params[:id]

    if @sponsorship.update sponsorship_params
      redirect_to admin_event_sponsorships_path, notice: "Sponsorships updated"
    else
      render :edit
    end
  end

  private

  def event = Event.find(params[:event_id])

  def sponsorship_params
    params.require(:sponsorship).permit(:price_paid, :reason, :event_id, :sponsor_id, :variant_id, :ogp_image)
  end
end
