FactoryBot.define do
  factory :invoice_sequence do
    sequence(:name) { |n| "Sequence #{n}" }

    trait :balkan2024 do
      name { "Balkan Ruby 2024" }
      initial_number { 10_001_049 }
    end
  end
end
