FactoryBot.define do
  factory :communication_draft do
    event { association :event, :balkan2024 }
  end
end
