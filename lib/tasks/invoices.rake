namespace :invoices do
  desc "Import invoices from JSON file"
  task :import, [:file_path] => :environment do |_task, args|
    data = JSON.parse File.read(args[:file_path])
    invoice_sequence = InvoiceSequence.find_by! initial_number: File.basename(args[:file_path], ".json").to_i

    data.each do |record|
      number = record["number"].to_i
      next if Invoice.exists?(invoice_sequence:, number:)

      Invoice.create!(
        invoice_sequence:,
        number:,
        issue_date: record["issue_date"],
        tax_event_date: record["tax_event_date"],
        customer_name: record["receiver_name"],
        receiver_email: record["receiver_email"],
        receiver_company_name: record["receiver_company_name"],
        receiver_company_idx: record["receiver_comapny_uid"],
        customer_vat_idx: record["receiver_comapny_vat_uid"],
        customer_address: record["receiver_address"],
        includes_vat: !record["skip_vat"],
        payment_method: record["payment_method"].presence,
        notes: record["notes"].presence,
        refunded_invoice: if record["for_invoice_number"].present?
                            Invoice.find_by number: record["for_invoice_number"]
                          end,
        items_attributes: record["items"].map { { **it, "unit_price" => it["unit_price"].to_d.abs } },
        created_at: record["issue_date"],
        updated_at: record["issue_date"],
      )
    end
  end
end
