FactoryBot.define do
  factory :invoice_sequence do
    sequence(:name) { |n| "Sequence #{n}" }
    sequence(:initial_number) { |n| n }

    trait :balkan2024 do
      name { "Balkan Ruby 2024" }
      initial_number { 10_001_049 }
    end
  end
end
