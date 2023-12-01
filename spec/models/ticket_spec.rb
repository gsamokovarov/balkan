require "rails_helper"

RSpec.case Ticket do
  test "#lts_url" do
    ticket = FactoryBot.create :ticket, :early_bird, name: "John Doe", email: "john@example.com"
    token = ticket.generate_token_for :event_access

    assert_eq ticket.lts_url, "http://2024.example.com/tickets/#{token}"
  end
end
