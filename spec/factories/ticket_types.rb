FactoryBot.define do
  factory :ticket_type do
    event { create(:event) }
    name { "Early Bird" }
    price { 150 }
    enabled { false }

    trait :enabled do
      enabled { true }
    end
  end
end
