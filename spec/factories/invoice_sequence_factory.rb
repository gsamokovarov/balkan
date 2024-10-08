FactoryBot.define do
  factory :invoice_sequence do
    trait :balkan2024 do
      initial_number { 10_001_049 }
    end
  end
end
