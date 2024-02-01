current_event = Event.find_or_create_by! name: "Balkan Ruby 2024" do
  _1.start_date = Date.new(2024, 4, 26)
  _1.end_date = Date.new(2024, 4, 27)
end

current_event.ticket_types.find_or_create_by! name: "Free" do
  _1.price = 0
  _1.enabled = false
end

current_event.ticket_types.find_or_create_by! name: "Early Bird" do
  _1.price = 100
  _1.enabled = true
end

current_event.ticket_types.find_or_create_by! name: "Regular" do
  _1.price = 120
  _1.enabled = true
end

current_event.ticket_types.find_or_create_by! name: "Supporter" do
  _1.price = 200
  _1.enabled = true
end
