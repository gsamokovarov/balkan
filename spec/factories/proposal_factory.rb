FactoryBot.define do
  factory :proposal do
    event
    sequence(:name) { |n| "Speaker #{n}" }
    sequence(:email) { |n| "speaker#{n}@example.com" }
    sequence(:title) { |n| "Talk #{n}" }
  end
end
