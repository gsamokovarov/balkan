class Admin::DashboardsController < Admin::ApplicationController
  def show
    @orders = Current.event.orders.completed.includes(tickets: :ticket_type).order("completed_at DESC")
  end
end
