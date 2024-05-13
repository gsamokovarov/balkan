require "rails_helper"

RSpec.case "Homepage", type: :feature do
  test "after speaker applications end date" do
    create :event, :balkan2025

    travel_to Time.zone.local(2024, 2, 3, 0, 0) do
      visit root_path

      assert_have_content page, "Buy a ticket"
    end
  end
end
