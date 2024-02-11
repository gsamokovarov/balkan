balkan2024 = Event.find_or_create_by! name: "Balkan Ruby 2024" do
  _1.start_date = Date.new(2024, 4, 26)
  _1.end_date = Date.new(2024, 4, 27)
end

balkan2024.ticket_types.find_or_create_by! name: "Free" do
  _1.price = 0
  _1.enabled = false
end

balkan2024.ticket_types.find_or_create_by! name: "Early Bird" do
  _1.price = 100
  _1.enabled = true
end

balkan2024.ticket_types.find_or_create_by! name: "Regular" do
  _1.price = 120
  _1.enabled = true
end

balkan2024.ticket_types.find_or_create_by! name: "Supporter" do
  _1.price = 200
  _1.enabled = true
end

balkan2024.invoice_sequence = InvoiceSequence.find_or_create_by! event: balkan2024 do
  _1.initial_number = 10001049
end
