require "rails_helper"

RSpec.case "Ticket", type: :feature do
  test "shows a ticket for an attendee" do
    ticket = create :ticket, :early_bird, :genadi

    visit ticket.event_access_url

    assert!(page).to have_field("Attendee name", with: "Genadi Samokovarov", disabled: true)
    assert!(page).to have_field("Attendee email", with: "genadi@hey.com", disabled: true)
    assert!(page).to have_field("T-shirt size", with: "S", disabled: true)
  end
end
