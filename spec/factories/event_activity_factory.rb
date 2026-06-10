FactoryBot.define do
  factory :event_activity do
    event { association :event, :balkan2024 }
    content { "Join us for a hike in the mountains." }
    published_at { Time.current }
  end
end
