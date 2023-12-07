require "rails_helper"

RSpec.case Ticket do
  test "#event_access_url" do
    order = create :order, completed_at: Time.current
    ticket = create :ticket, :early_bird, order:, name: "John Doe", email: "john@example.com"
    token = ticket.generate_token_for :event_access

    assert_eq ticket.event_access_url, "http://example.com/tickets/#{token}"
  end
end
