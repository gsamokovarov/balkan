require "csv"

class Admin::DashboardsController < Admin::ApplicationController
  def show
    @orders = Order.includes(tickets: :ticket_type).where("completed_at IS NOT NULL").order("completed_at DESC")
  end

  def report
    orders = Order.includes(tickets: :ticket_type).where("completed_at IS NOT NULL").order("completed_at DESC")
    report = CSV.generate do |csv|
      csv << %w[Date Name Amount Refunded]
      orders.each do |order|
        csv << [order.completed_at.to_date.iso8601, order.customer_name, order.amount, order.refunded_amount]
      end
    end

    send_data report, filename: "orders-#{Date.current.iso8601}.csv", type: :csv
  end
end
