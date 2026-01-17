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
        customer_name: record["receiver_name"].presence,
        receiver_email: record["receiver_email"].presence,
        receiver_company_name: record["receiver_company_name"].presence,
        receiver_company_idx: record["receiver_comapny_uid"].presence,
        customer_vat_idx: record["receiver_comapny_vat_uid"].presence,
        customer_address: record["receiver_address"].presence,
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
