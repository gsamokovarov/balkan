require "rails_helper"

RSpec.case Admin::TicketsController, type: :request do
  test "staff can check in a ticket" do
    event = create :event, :balkan2025
    sign_in create(:user, :staff)
    ticket = create :ticket, :early_bird, name: "Attendee", email: "a@example.com", order: create(:order, event:)

    post checkin_admin_event_ticket_path(event, ticket)

    assert_have_http_status response, :redirect
    assert_eq ticket.reload.checked_in?, true
  end

  test "checkin redirects back when a Referer is present" do
    event = create :event, :balkan2025
    sign_in create(:user, :staff)
    ticket = create :ticket, :early_bird, name: "Attendee", email: "a@example.com", order: create(:order, event:)

    post checkin_admin_event_ticket_path(event, ticket), headers: { "HTTP_REFERER" => "http://www.example.com/somewhere" }

    assert_redirected_to "http://www.example.com/somewhere"
  end

  test "checkin falls back to the ticket event_access_url when no Referer" do
    event = create :event, :balkan2025
    sign_in create(:user, :staff)
    ticket = create :ticket, :early_bird, name: "Attendee", email: "a@example.com", order: create(:order, event:)

    post checkin_admin_event_ticket_path(event, ticket)

    assert_redirected_to ticket.event_access_url
  end

  test "checkin requires authentication" do
    event = create :event, :balkan2025
    ticket = create :ticket, :early_bird, name: "Attendee", email: "a@example.com", order: create(:order, event:)

    post checkin_admin_event_ticket_path(event, ticket)

    assert_have_http_status response, :redirect
    assert_eq ticket.reload.checked_in?, false
  end
end
