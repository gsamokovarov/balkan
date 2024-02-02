require "rails_helper"

RSpec.case "Homepage", type: :feature do
  test "after speaker applications end date" do
    create :event, :balkan2024

    travel_to Time.zone.local(2024, 2, 3, 0, 0) do
      visit root_path

      assert_not_have_content page, "Speaker applications close in"
      assert_not_have_content page, "Become a speaker"
    end
  end

  test "subscribes user to a newsletter with email" do
    create :event, :balkan2024

    visit root_path

    fill_in "subscriber_email", with: "genadi@hey.com"

    click_button "Subscribe"

    assert_have_content page, "We'll keep you up to date on genadi@hey.com"
  end

  test "unsubscribes user from a newsletter with a token" do
    event = create :event, :balkan2024
    subscriber = create(:subscriber, :genadi, event:)

    visit subscriber.cancel_url

    assert_have_content page, "You are about to unsubscribe genadi@hey.com"

    click_button "Unsubscribe"

    assert_have_content page, "You will no longer receive updates on genadi@hey.com"
  end
end
