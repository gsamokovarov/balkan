FactoryBot.define do
  factory :subscriber do
    event { association :event, :balkan2024 }

    trait :genadi do
      email { "genadi@hey.com" }
    end
  end
end
