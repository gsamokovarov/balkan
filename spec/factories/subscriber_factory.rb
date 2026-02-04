FactoryBot.define do
  factory :subscriber do
    sequence(:email) { |n| "subscriber#{n}@example.com" }
  end
end
