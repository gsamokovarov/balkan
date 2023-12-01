FactoryBot.define do
  factory :ticket do
    order

    shirt_size { "M" }

    trait :enabled do
      enabled { true }
    end

    trait :early_bird do
      description { "Early Bird" }
      price { 150 }
    end
  end
end
