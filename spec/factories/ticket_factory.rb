FactoryBot.define do
  factory :ticket do
    order

    shirt_size { "M" }

    trait :early_bird do
      price { 150 }
    end

    trait :genadi do
      name { "Genadi Samokovarov" }
      email { "genadi@hey.com" }
      shirt_size { "S" }
    end
  end
end
