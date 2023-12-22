FactoryBot.define do
  factory :ticket_type do
    event { association :event, :balkan2024 }
    name { "Early Bird" }
    price { 100 }
    enabled { false }

    trait :enabled do
      enabled { true }
    end
  end
end
