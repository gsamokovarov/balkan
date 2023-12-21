FactoryBot.define do
  factory :subscriber do
    event

    trait :genadi do
      email { "genadi@hey.com" }
    end
  end
end
