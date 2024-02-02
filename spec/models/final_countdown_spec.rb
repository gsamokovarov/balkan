require "rails_helper"

RSpec.case FinalCountdown do
  test "date approaching" do
    travel_to Time.zone.local(2024, 2, 1, 12, 0, 0) do
      countdown = FinalCountdown.until Date.new(2024, 2, 2)

      assert_eq countdown.days, 1
      assert_eq countdown.hours, 11
      assert_eq countdown.ongoing?, true
    end
  end

  test "counters as pair of units and value" do
    travel_to Time.zone.local(2024, 2, 1, 12, 0, 0) do
      countdown = FinalCountdown.until Date.new(2024, 2, 2)

      assert_eq countdown.counters, [["days", 1], ["hours", 11]]
    end
  end

  test "same day" do
    travel_to Time.zone.local(2024, 2, 2, 23, 0, 0) do
      countdown = FinalCountdown.until Date.new(2024, 2, 2)

      assert_eq countdown.days, 0
      assert_eq countdown.hours, 0
      assert_eq countdown.ongoing?, true
    end
  end

  test "is not ongoing after countdown date" do
    travel_to Time.zone.local(2024, 2, 3, 12, 0, 0) do
      countdown = FinalCountdown.until Date.new(2024, 2, 2)

      assert_eq countdown.days, -1
      assert_eq countdown.ongoing?, false
    end
  end
end
