require "rails_helper"

RSpec.case "Ticket", type: :feature do
  test "shows a ticket for an attendee" do
    event = create :event, :balkan2025
    ticket = create(:ticket, :early_bird, :genadi, event:)

    visit ticket.event_access_url

    assert_have_field page, "Attendee name", with: "Genadi Samokovarov", disabled: true
    assert_have_field page, "Attendee email", with: "genadi@hey.com", disabled: true
    assert_have_field page, "T-shirt size", with: "S", disabled: true
  end

  def assert_have_field(page, ...)
    assert!(page).to have_field(...)
  end
end
