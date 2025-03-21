FactoryBot.define do
  factory :announcement do
    event
    message { "This is a test announcement message" }
    active { false }
  end
end
