FactoryBot.define do
  factory :event do
    name { "Balkan Ruby" }
    start_date { Time.zone.today + 5.days }
    end_date { Time.zone.today + 6.days }

    trait :balkan2024 do
      name { "Balkan Ruby 2024" }
      start_date { Time.zone.parse("2024-04-26") }
      end_date { Time.zone.parse("2024-04-27") }
    end
  end
end
