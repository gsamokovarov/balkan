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
end
