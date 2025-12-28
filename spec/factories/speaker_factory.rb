FactoryBot.define do
  factory :speaker do
    sequence(:name) { |n| "Speaker #{n}" }
    sequence(:email) { |n| "speaker#{n}@example.com" }
  end
end
