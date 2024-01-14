require "rails_helper"

RSpec.case DateCountdown do
  test "date approaching" do
    travel_to Time.zone.local(2024, 2, 1, 12, 0, 0) do
      countdown = DateCountdown.until Date.new(2024, 2, 2)

      assert_eq countdown.days, 1
      assert_eq countdown.hours, 11
      assert_eq countdown.past?, false
    end
  end

  test "same day" do
    travel_to Time.zone.local(2024, 2, 2, 23, 0, 0) do
      countdown = DateCountdown.until Date.new(2024, 2, 2)

      assert_eq countdown.days, 0
      assert_eq countdown.hours, 0
      assert_eq countdown.past?, false
    end
  end

  test "after countdown date" do
    travel_to Time.zone.local(2024, 2, 3, 12, 0, 0) do
      countdown = DateCountdown.until Date.new(2024, 2, 2)

      assert_eq countdown.days, -1
      assert_eq countdown.past?, true
    end
  end
end
