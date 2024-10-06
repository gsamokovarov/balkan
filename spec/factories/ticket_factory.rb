FactoryBot.define do
  factory :ticket do
    order

    shirt_size { "M" }

    trait :early_bird do
      ticket_type { association :ticket_type, name: "Early Bird", price: 100 }
      price { 100 }
    end

    trait :genadi do
      name { "Genadi Samokovarov" }
      email { "genadi@hey.com" }
      shirt_size { "S" }
    end
  end
end
