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
    sequence_identifier = File.basename(file_path, ".json").to_i

    # Find sequence by matching the number range - the file is named after
    # the sequence's starting number prefix (e.g., 10001049 for sequence starting at 10001049)
    invoice_sequence = InvoiceSequence.find_by(initial_number: sequence_identifier)

    unless invoice_sequence
      puts "Error: No invoice sequence found with initial_number #{sequence_identifier}"
      puts "Available sequences:"
      InvoiceSequence.all.each do |seq|
        puts "  - #{seq.name.presence || '(unnamed)'}: initial_number=#{seq.initial_number}"
      end
      exit 1
    end

    puts "Importing #{data.size} invoices into sequence '#{invoice_sequence.name.presence || '(unnamed)'}' (ID: #{invoice_sequence.id}, initial: #{invoice_sequence.initial_number})"

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
        receiver_company_idx: record["receiver_comapny_uid"],
        customer_vat_idx: record["receiver_comapny_vat_uid"],
        customer_address: record["receiver_address"],
        includes_vat: !record["skip_vat"],
        payment_method: record["payment_method"].presence,
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
