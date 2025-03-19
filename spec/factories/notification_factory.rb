FactoryBot.define do
  factory :notification do
    event
    message { "This is a test notification message" }
    active { false }
  end
end
