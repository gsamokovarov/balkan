FactoryBot.define do
  factory :contract_template do
    event { association :event, :balkan2025 }
    name { "Sponsorship Agreement" }
    content { "# Agreement for {{ event_name }}\n\n**{{ company_name }}** pays **{{ price }}** Euro." }
  end
end
