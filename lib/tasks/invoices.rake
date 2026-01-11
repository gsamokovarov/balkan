namespace :invoices do
  desc "Import invoices from JSON file"
  task :import, [:file_path] => :environment do |_task, args|
    file_path = args[:file_path]

    unless file_path && File.exist?(file_path)
      puts "Usage: bin/rails invoices:import[path/to/file.json]"
      puts "Error: File not found: #{file_path}"
      exit 1
    end

    data = JSON.parse(File.read(file_path))
    sequence_name = File.basename(file_path, ".json")

    invoice_sequence = InvoiceSequence.find_or_create_by!(name: sequence_name) do |seq|
      first_number = data.first["number"].to_i
      seq.initial_number = first_number
    end

    puts "Importing #{data.size} invoices into sequence '#{sequence_name}' (ID: #{invoice_sequence.id})"

    imported = 0
    skipped = 0
    errors = 0

    invoice_number_map = {}

    data.each_with_index do |record, index|
      number = record["number"].to_i

      if Invoice.exists?(invoice_sequence:, number:)
        skipped += 1
        invoice_number_map[record["number"]] = Invoice.find_by(invoice_sequence:, number:).id
        next
      end

      invoice = Invoice.new(
        invoice_sequence:,
        number:,
        issue_date: Date.parse(record["issue_date"]),
        tax_event_date: Date.parse(record["tax_event_date"]),
        customer_name: record["receiver_name"],
        receiver_email: record["receiver_email"],
        receiver_company_name: record["receiver_company_name"],
        receiver_company_uid: record["receiver_comapny_uid"],
        customer_vat_id: record["receiver_comapny_vat_uid"],
        customer_address: record["receiver_address"],
        includes_vat: !record["skip_vat"],
        notes: record["notes"].presence
      )

      record["items"].each do |item|
        invoice.items.build(
          description_en: item["description_en"],
          description_bg: item["description_bg"],
          unit_price: item["unit_price"].to_d
        )
      end

      if invoice.save
        imported += 1
        invoice_number_map[record["number"]] = invoice.id
        print "." if (imported % 100).zero?
      else
        errors += 1
        puts "\nError importing invoice ##{number}: #{invoice.errors.full_messages.join(', ')}"
      end
    end

    puts "\nLinking credit notes to refunded invoices..."

    credit_notes_linked = 0
    data.each do |record|
      next if record["for_invoice_number"].blank?

      invoice_id = invoice_number_map[record["number"]]
      refunded_invoice_id = invoice_number_map[record["for_invoice_number"]]

      if invoice_id && refunded_invoice_id
        Invoice.where(id: invoice_id).update_all(refunded_invoice_id:)
        credit_notes_linked += 1
      end
    end

    puts "\nImport complete!"
    puts "  Imported: #{imported}"
    puts "  Skipped (already exist): #{skipped}"
    puts "  Errors: #{errors}"
    puts "  Credit notes linked: #{credit_notes_linked}"
  end
end
