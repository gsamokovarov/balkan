FactoryBot.define do
  factory :event do
    trait :balkan2024 do
      name { "Balkan Ruby 2024" }
      start_date { Date.new 2024, 4, 26 }
      end_date { Date.new 2024, 4, 27 }
      speaker_applications_end_date { Date.new 2024, 2, 2 }
      invoice_sequence { association :invoice_sequence, :balkan2024, event: instance }
    end
  end
end
