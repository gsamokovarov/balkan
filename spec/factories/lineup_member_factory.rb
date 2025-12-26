FactoryBot.define do
  factory :lineup_member do
    event
    speaker
    status { :confirmed }

    trait :pending do
      status { :pending }
    end
  end
end
