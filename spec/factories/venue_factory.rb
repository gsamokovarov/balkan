FactoryBot.define do
  factory :venue do
    name { "Venue #{rand 1000}" }
    description { "A beautiful venue for conferences" }
    address { "123 Conference Street, Cityname" }
    directions { "Take the metro to Central Station and walk 5 minutes" }
    place_id { "place_id_#{rand 1000}" }
    url { "https://venue-example.com" }
  end
end
