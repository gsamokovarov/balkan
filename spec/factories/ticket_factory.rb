FactoryBot.define do
  factory :ticket do
    order

    shirt_size { "M" }

    trait :early_bird do
      price { 150 }
    end
  end
end
