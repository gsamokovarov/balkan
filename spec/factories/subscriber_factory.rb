FactoryBot.define do
  factory :subscriber do
    event
    sequence(:email) { |n| "subscriber#{n}@example.com" }
  end
end
