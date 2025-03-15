FactoryBot.define do
  factory :sponsorship_variant do
    association :package, factory: :sponsorship_package
    name { "Variant #{rand(1000)}" }
    price { rand(1000..10000) }
    perks { "• Logo on website\n• Mention in emails\n• Social media shoutout" }
    quantity { nil } # Default to unlimited
  end
end
