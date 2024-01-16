require "csv"

module OrderReport
  extend self

  CSV_HEADER = %w[Date Name Amount Refunded]

  def export_csv(orders)
    CSV.generate do |csv|
      csv << CSV_HEADER
      orders.each do |order|
        csv << [order.completed_at.to_date.iso8601, order.customer_name, order.amount, order.refunded_amount]
      end
    end
  end
end
