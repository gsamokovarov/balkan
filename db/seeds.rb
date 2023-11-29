event = Event.find_or_create_by!(name: "Balkan Ruby") do
  _1.start_date = Date.new(2024, 4, 26)
  _1.end_date = Date.new(2024, 4, 27)
end

TicketType.find_or_create_by!(event: event, name: "Early Bird") do
  _1.price = 150
  _1.enabled = true
end

TicketType.find_or_create_by!(event: event, name: "Regular") do
  _1.price = 175
  _1.enabled = false
end
