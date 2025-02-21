class Admin::DashboardsController < Admin::ApplicationController
  def show
    @orders = Current.event.orders.completed.includes(tickets: :ticket_type).order(completed_at: :desc)
  end

  def orders
    @orders = scope Current.event.orders.completed.order(completed_at: :desc)
  end
end
