FactoryBot.define do
  factory :invoice do
    order
    invoice_sequence { association :invoice_sequence, :balkan2024 }
  end
end
