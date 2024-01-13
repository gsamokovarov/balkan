namespace :accounting do
  desc "Generate a report for accounting"
  task report: :environment do
    orders = Order.where("completed_at IS NOT NULL").order "completed_at DESC"

    puts "Date,Name,Amount,Refunded"
    orders.each do |order|
      puts [order.created_at.to_date.iso8601, order.customer_name, order.amount, order.refunded_amount].join(",")
    end
  end
end
