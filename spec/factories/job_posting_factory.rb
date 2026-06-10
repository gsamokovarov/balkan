FactoryBot.define do
  factory :job_posting do
    event { association :event, :balkan2024 }
    sponsor
    title { "Ruby Developer" }
    description { "Come write Ruby with us." }
    published_at { Time.current }
  end
end
