namespace :accounting do
  desc "Generate a report for accounting"
  task report: :environment do
    orders = Order.where("completed_at IS NOT NULL").order "completed_at DESC"

    puts OrderReport.export_csv(orders)
  end
end
