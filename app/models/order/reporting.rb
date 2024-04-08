require "csv"
require "rubygems/package"

module Order::Reporting
  extend self

  CSV_HEADER = %w[Date Name Amount Refunded]

  def export_to_csv(orders)
    CSV.generate do |csv|
      csv << CSV_HEADER
      orders.each do |order|
        csv << [order.completed_at.to_date.iso8601, order.name, order.amount, order.refunded_amount]
      end
    end
  end

  def export_invoices_to_tar(orders)
    tar_io = StringIO.new
    Gem::Package::TarWriter.new tar_io do |tar|
      orders.each do |order|
        next unless order.invoicable?

        invoice = order.invoice

        tar.add_file(invoice.filename(locale: :en), 0o644) { _1.write invoice.document(locale: :en) }
        tar.add_file(invoice.filename(locale: :bg), 0o644) { _1.write invoice.document(locale: :bg) }
      end
    end
    tar_io.rewind
    tar_io.read
  end
end
