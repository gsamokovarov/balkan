require "rails_helper"

RSpec.case "Newsletter subscription", type: :feature do
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
