FactoryBot.define do
  factory :event do
    invoice_sequence { association :invoice_sequence, :balkan2024 }

    trait :balkan2024 do
      name { "Balkan Ruby 2024" }
      host { "www.example.com" }
      start_date { Date.new 2024, 4, 26 }
      end_date { Date.new 2024, 4, 27 }
      speaker_applications_end_date { Date.new 2024, 2, 2 }
    end

    trait :balkan2025 do
      name { "Balkan Ruby 2025" }
      host { "www.example.com" }
      start_date { Date.new 2025, 4, 24 }
      end_date { Date.new 2025, 4, 25 }
    end
  end
end
