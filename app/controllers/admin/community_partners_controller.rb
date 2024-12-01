class Admin::CommunityPartnersController < Admin::ApplicationController
  def index
    @community_partners = CommunityPartner.all
  end

  def show
    @community_partner = CommunityPartner.find params[:id]
  end

  def new
    @community_partner = CommunityPartner.new
  end

  def create
    @community_partner = CommunityPartner.new community_partner_params

    if @community_partner.save
      redirect_to admin_event_community_partners_path(event), notice: "Community partner created"
    else
      render :new
    end
  end

  def edit
    @community_partner = CommunityPartner.find params[:id]
  end

  def update
    @community_partner = CommunityPartner.find params[:id]

    if @community_partner.update community_partner_params
      redirect_to admin_event_community_partners_path(event), notice: "Community partner updated"
    else
      render :edit
    end
  end

  private

  def community_partner_params = params.require(:community_partner).permit(:event_id, :name, :url, :logo)

  helper_method def event = @event ||= Event.find(params[:event_id])
end
