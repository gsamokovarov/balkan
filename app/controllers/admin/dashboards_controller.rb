class Admin::DashboardsController < Admin::ApplicationController
  def show
    @orders = Order.completed.includes(tickets: :ticket_type).order("completed_at DESC")
  end
end
