require "rubygems/package"

module Invoice::Reporting
  extend self

  def export_to_tar(invoices)
    tar_io = StringIO.new
    Gem::Package::TarWriter.new tar_io do |tar|
      invoices.each do |invoice|
        tar.add_file(invoice.filename(locale: :en), 0o644) { it.write invoice.document(locale: :en) }
        tar.add_file(invoice.filename(locale: :bg), 0o644) { it.write invoice.document(locale: :bg) }
      end
    end
    tar_io.rewind
    tar_io.read
  end
end
