FactoryBot.define do
  factory :contract do
    event { association :event, :balkan2025 }
    contract_template { association :contract_template, event: }
    agreement_date { Date.new 2025, 3, 1 }
    price { 1000 }
    company_name { "Acme Corp" }
    company_address { "123 Main St" }
    company_country { "Germany" }
    representative_name { "Jane Doe" }
  end
end
