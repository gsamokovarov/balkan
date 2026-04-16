require "rails_helper"

RSpec.case TicketsController, "#wallet_pass", type: :request do
  test "responds with a pkpass file" do
    event = create :event, :balkan2025
    ticket_type = create(:ticket_type, :enabled, event:)
    ticket = create :ticket, :early_bird, ticket_type:,
                                          name: "Genadi Samokovarov",
                                          email: "genadi@hey.com"

    fake_pass = "fake-pkpass-data"
    allow(WalletPass).to receive(:to_pkpass).and_return(fake_pass)

    token = ticket.generate_token_for :event_access
    get ticket_path(token, format: :pkpass)

    assert_have_http_status response, :ok
    assert_eq response.content_type, "application/vnd.apple.pkpass"
    assert_eq response.body, fake_pass
  end

  test "returns 404 for invalid token" do
    get ticket_path("invalid-token", format: :pkpass)

    assert_have_http_status response, :not_found
  end
end
