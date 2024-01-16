class Admin::DashboardsController < Admin::ApplicationController
  def show
    @orders = Order.includes(tickets: :ticket_type).where("completed_at IS NOT NULL").order("completed_at DESC")
  end

  def report
    orders = Order.where("completed_at IS NOT NULL").order("completed_at DESC")
    report = OrderReport.export_csv orders

    send_data report, filename: "orders-#{Date.current.iso8601}.csv", type: :csv
  end
end
