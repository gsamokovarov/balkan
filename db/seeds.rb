current_event = Event.find_or_create_by! name: "Balkan Ruby 2024" do
  _1.start_date = Date.new(2024, 4, 26)
  _1.end_date = Date.new(2024, 4, 27)
end

current_event.ticket_types.find_or_create_by! name: "Early Bird" do
  _1.price = 150
  _1.enabled = true
end

current_event.ticket_types.find_or_create_by! name: "Regular" do
TicketType.find_or_create_by!(event: event, name: "Regular") do
  _1.price = 175
  _1.enabled = false
end
