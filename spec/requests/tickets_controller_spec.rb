require "rails_helper"

RSpec.case Webhooks::StripesController, type: :request do
  test "order tickets are not created on checkout.session.expired" do
    event = create :event, :balkan2025
    ticket_type = create(:ticket_type, :enabled, event:)
    ticket = create :ticket, :early_bird, ticket_type:,
                                          name: "Genadi Samokovarov",
                                          email: "genadi@hey.com"

    get ticket.event_access_url

    assert_have_http_status response, :ok
  end
end
