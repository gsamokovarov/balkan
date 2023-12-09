class Admin::DashboardsController < Admin::ApplicationController
  def show
    @orders = Order.includes(:tickets).where("completed_at IS NOT NULL").order("completed_at DESC")
  end
end
