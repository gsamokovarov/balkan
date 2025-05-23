require "rails_helper"

RSpec.describe FinalCountdown do
  test "calculates correct days and hours when event is tomorrow at 2:30 PM" do
    travel_to Time.zone.local(2024, 1, 15, 14, 30, 0) do
      countdown = FinalCountdown.until Date.new(2024, 1, 16)

      assert_eq countdown.days, 1
      assert_eq countdown.hours, 9
    end
  end

  test "calculates correct days and hours when event is in 2 days" do
    travel_to Time.zone.local(2024, 1, 15, 14, 30, 0) do
      countdown = FinalCountdown.until Date.new(2024, 1, 17)

      assert_eq countdown.days, 2
      assert_eq countdown.hours, 9
    end
  end

  test "calculates correct days and hours when event is in 10 days" do
    travel_to Time.zone.local(2024, 1, 15, 14, 30, 0) do
      countdown = FinalCountdown.until Date.new(2024, 1, 25)

      assert_eq countdown.days, 10
      assert_eq countdown.hours, 9
    end
  end

  test "calculates correct days when event is later today" do
    travel_to Time.zone.local(2024, 1, 15, 14, 30, 0) do
      countdown = FinalCountdown.until Date.new(2024, 1, 15)

      assert_eq countdown.days, 0
      assert_eq countdown.hours, 9
    end
  end

  test "shows 0 days and remaining hours when event is today at noon" do
    travel_to Time.zone.local(2024, 1, 15, 12, 0, 0) do
      countdown = FinalCountdown.until Date.current

      assert_eq countdown.days, 0
      assert_eq countdown.hours, 11
      assert countdown.ongoing?
    end
  end

  test "shows 0 days and remaining hours when event is today in evening" do
    travel_to Time.zone.local(2024, 1, 15, 20, 0, 0) do
      countdown = FinalCountdown.until Date.current

      assert_eq countdown.days, 0
      assert_eq countdown.hours, 3
      assert countdown.ongoing?
    end
  end

  test "shows negative days and 0 hours for yesterday" do
    travel_to Time.zone.local(2024, 1, 15, 14, 30, 0) do
      countdown = FinalCountdown.until Date.new(2024, 1, 14)

      assert_eq countdown.days, -1
      assert_eq countdown.hours, 0
      assert !countdown.ongoing?
    end
  end

  test "shows negative days and 0 hours for last week" do
    travel_to Time.zone.local(2024, 1, 15, 14, 30, 0) do
      countdown = FinalCountdown.until Date.new(2024, 1, 8)

      assert_eq countdown.days, -7
      assert_eq countdown.hours, 0
      assert !countdown.ongoing?
    end
  end

  test "handles time at midnight correctly" do
    travel_to Time.zone.local(2024, 1, 15, 0, 0, 0) do
      countdown = FinalCountdown.until Date.new(2024, 1, 16)

      assert_eq countdown.days, 1
      assert_eq countdown.hours, 23
    end
  end

  test "handles time at 23:59:59 correctly" do
    travel_to Time.zone.local(2024, 1, 15, 23, 59, 59) do
      countdown = FinalCountdown.until Date.new(2024, 1, 16)

      assert_eq countdown.days, 1
      assert_eq countdown.hours, 0
    end
  end

  test "handles early morning correctly" do
    travel_to Time.zone.local(2024, 1, 15, 1, 0, 0) do
      countdown = FinalCountdown.until Date.new(2024, 1, 16)

      assert_eq countdown.days, 1
      assert_eq countdown.hours, 22
    end
  end

  test "shows decreasing hours as day progresses for same target" do
    target_date = Date.new 2024, 1, 16

    travel_to Time.zone.local(2024, 1, 15, 6, 0, 0)
    morning_countdown = FinalCountdown.until target_date
    travel_back

    travel_to Time.zone.local(2024, 1, 15, 14, 0, 0)
    afternoon_countdown = FinalCountdown.until target_date
    travel_back

    travel_to Time.zone.local(2024, 1, 15, 22, 0, 0)
    evening_countdown = FinalCountdown.until target_date
    travel_back

    assert_eq morning_countdown.days, 1
    assert_eq afternoon_countdown.days, 1
    assert_eq evening_countdown.days, 1

    assert morning_countdown.hours > afternoon_countdown.hours
    assert afternoon_countdown.hours > evening_countdown.hours
  end

  test "counters returns an array of days and hours" do
    countdown = FinalCountdown.new days: 5, hours: 12

    assert_eq countdown.counters, [["days", 5], ["hours", 12]]
  end

  test "counters converts values to integers" do
    countdown = FinalCountdown.new days: 5.7, hours: 12.9

    assert_eq countdown.counters, [["days", 5], ["hours", 12]]
  end

  test "ongoing? returns true when days are positive" do
    countdown = FinalCountdown.new days: 1, hours: 0
    assert countdown.ongoing?
  end

  test "ongoing? returns true when days are zero" do
    countdown = FinalCountdown.new days: 0, hours: 5
    assert countdown.ongoing?
  end

  test "ongoing? returns false when days are negative" do
    countdown = FinalCountdown.new(days: -1, hours: 0)
    assert !countdown.ongoing?
  end

  test "hours calculation now correctly breaks down total time" do
    travel_to Time.zone.local(2024, 1, 15, 14, 30, 0) do
      countdown = FinalCountdown.until Date.new(2024, 1, 16)

      assert_eq countdown.days, 1
      assert_eq countdown.hours, 9
    end
  end

  test "hours calculation shows correct fractional day part" do
    travel_to Time.zone.local(2024, 1, 15, 14, 30, 0) do
      countdown = FinalCountdown.until Date.new(2024, 1, 20)

      assert_eq countdown.days, 5
      assert_eq countdown.hours, 9
    end
  end
end
