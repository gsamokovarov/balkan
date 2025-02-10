invoice_sequence = InvoiceSequence.find_or_create_by! initial_number: 10_001_049

balkan2024 = Event.find_or_create_by! name: "Balkan Ruby 2024" do
  it.start_date = Date.new 2024, 4, 26
  it.end_date = Date.new 2024, 4, 27
  it.host = "2024.balkanruby.com"
end

balkan2024.ticket_types.find_or_create_by! name: "Free" do
  it.price = 0
  it.enabled = false
end

balkan2024.ticket_types.find_or_create_by! name: "Early Bird" do
  it.price = 100
  it.enabled = true
end

balkan2024.ticket_types.find_or_create_by! name: "Regular" do
  it.price = 120
  it.enabled = true
end

balkan2024.ticket_types.find_or_create_by! name: "Supporter" do
  it.price = 200
  it.enabled = true
end

balkan2025 = Event.find_or_create_by! name: "Balkan Ruby 2025" do
  it.start_date = Date.new 2025, 4, 25
  it.end_date = Date.new 2025, 4, 26
  it.invoice_sequence = invoice_sequence
  it.host = "balkanruby.com"
end

balkan2025.ticket_types.find_or_create_by! name: "Free" do
  it.price = 0
  it.enabled = false
end

balkan2025.ticket_types.find_or_create_by! name: "Blind Bird" do
  it.price = 90
  it.enabled = true
end

balkan2025.ticket_types.find_or_create_by! name: "Early Bird" do
  it.price = 120
  it.enabled = true
end

balkan2025.ticket_types.find_or_create_by! name: "Regular" do
  it.price = 150
  it.enabled = true
end

balkan2025.ticket_types.find_or_create_by! name: "Supporter" do
  it.price = 200
  it.enabled = true
end

banitsa2024 = Event.find_or_create_by! name: "Ruby Banitsa 2024" do
  it.start_date = Date.new 2024, 12, 7
  it.end_date = Date.new 2024, 12, 7
  it.invoice_sequence = invoice_sequence
  it.host = "conf.rubybanitsa.com"
end

banitsa2024.ticket_types.find_or_create_by! name: "Free" do
  it.price = 0
  it.enabled = false
end

banitsa2024.ticket_types.find_or_create_by! name: "Student" do
  it.price = "12.34"
  it.enabled = true
end

banitsa2024.ticket_types.find_or_create_by! name: "Regular" do
  it.price = "42.0"
  it.enabled = true
end

banitsa2024.ticket_types.find_or_create_by! name: "Supporter" do
  it.price = "69"
  it.enabled = true
end

User.find_or_create_by! email: "admin@example.com" do
  it.name = "Admin"
  it.password = "admin"
end

puts "Admin user: admin@example.com with password 'admin'"
