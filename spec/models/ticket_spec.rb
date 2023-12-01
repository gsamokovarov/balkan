require "rails_helper"

RSpec.describe Ticket do
  test "#lts_url" do
    ticket = FactoryBot.create :ticket, :early_bird, name: "John Doe", email: "john@example.com"
    token = ticket.generate_token_for :event_access

    assert_equal ticket.lts_url, "http://2024.example.com/tickets/#{token}"
  end
end
