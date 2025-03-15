FactoryBot.define do
  factory :sponsorship do
    event
    association :sponsor
    association :variant, factory: :sponsorship_variant
    price_paid { variant.price }
    reason { "Standard sponsorship" }
  end
end
