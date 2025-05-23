FactoryBot.define do
  factory :sponsorship_package do
    event
    name { "Sponsorship Package #{rand 1000}" }
    description { "Description for sponsorship package" }
  end
end
