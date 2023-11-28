FactoryBot.define do
  factory :event do
    name { "Balkan Ruby" }
    start_date { Time.zone.today + 5.days }
    end_date { Time.zone.today + 6.days }
  end
end
