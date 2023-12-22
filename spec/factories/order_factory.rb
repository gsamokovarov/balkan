FactoryBot.define do
  factory :order do
    event { association :event, :balkan2024 }
  end
end
