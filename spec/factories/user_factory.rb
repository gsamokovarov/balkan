FactoryBot.define do
  factory :user do
    sequence(:name)  { "User #{it}" }
    sequence(:email) { "user#{it}@example.com" }
    password { "password" }
    role { :organizer }

    trait :staff do
      role { :staff }
    end

    trait :organizer do
      role { :organizer }
    end
  end
end
