require "rails_helper"

RSpec.case "Event" do
  test "speaker application countdown" do
    event = create :event, :balkan2024

    travel_to Time.zone.local(2024, 1, 1, 12, 0, 0) do
      countdown = event.speaker_applications_countdown

      assert_eq countdown.days, 32
      assert_eq countdown.hours, 11
    end
  end

  test "speakers only include confirmed lineup members" do
    event = create :event, :balkan2024
    confirmed = create :speaker
    pending = create :speaker
    cancelled = create :speaker

    create :lineup_member, event:, speaker: confirmed, status: :confirmed
    create :lineup_member, event:, speaker: pending, status: :pending
    create :lineup_member, event:, speaker: cancelled, status: :cancelled

    assert_eq event.speakers.to_a, [confirmed]
  end
end
