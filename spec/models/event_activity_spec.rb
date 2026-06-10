require "rails_helper"

RSpec.case "EventActivity" do
  test "relevant while the event is upcoming" do
    activity = create :event_activity

    travel_to Time.zone.local(2024, 4, 1, 12, 0, 0) do
      assert_eq activity.relevant?, true
    end
  end

  test "relevant within a month after the event ends" do
    activity = create :event_activity

    travel_to Time.zone.local(2024, 5, 26, 12, 0, 0) do
      assert_eq activity.relevant?, true
    end
  end

  test "not relevant a month after the event ends" do
    activity = create :event_activity

    travel_to Time.zone.local(2024, 5, 27, 12, 0, 0) do
      assert_eq activity.relevant?, false
    end
  end

  test "not relevant when unpublished" do
    activity = create :event_activity, published_at: nil

    travel_to Time.zone.local(2024, 4, 1, 12, 0, 0) do
      assert_eq activity.relevant?, false
    end
  end
end
