require "rails_helper"

RSpec.case Announcement do
  test "activating a announcement deactivates all others" do
    event = create :event, :balkan2025
    announcement1 = create :announcement, event:, active: true
    announcement2 = create :announcement, event:, active: false

    Announcement.activate announcement2

    assert_eq announcement1.reload.active, false
    assert_eq announcement2.reload.active, true
  end

  test "activating a announcement works when none are active" do
    event = create :event, :balkan2025
    announcement = create :announcement, event:, active: false

    Announcement.activate announcement

    assert_eq announcement.reload.active, true
  end

  test "deactivating announcements turns off all active ones" do
    event = create :event, :balkan2025
    announcement1 = create :announcement, event:, active: true
    announcement2 = create :announcement, event:, active: false

    Announcement.deactivate event

    assert_eq announcement1.reload.active, false
    assert_eq announcement2.reload.active, false
  end

  test "active returns the currently active announcement" do
    event = create :event, :balkan2025
    create :announcement, event:, active: false
    active_announcement = create :announcement, event:, active: true

    assert_eq active_announcement, Announcement.active_for(event)
  end

  test "active returns nil when no announcements are active" do
    event = create :event, :balkan2025
    create :announcement, event:, active: false

    assert_eq nil, Announcement.active_for(event)
  end

  test "only one announcement can be active at the database level" do
    event = create :event, :balkan2025
    create :announcement, event:, active: true
    second_announcement = build :announcement, event:, active: true

    assert_raise_error ActiveRecord::RecordNotUnique do
      second_announcement.save! validate: false
    end
  end

  test "allows multiple inactive announcements" do
    event = create :event, :balkan2025
    create :announcement, event:, active: false
    second_announcement = build :announcement, event:, active: false

    second_announcement.save!

    assert_eq second_announcement.persisted?, true
  end

  test "allows activating a new announcement after deactivating others" do
    event = create :event, :balkan2025
    create :announcement, event:, active: true
    second_announcement = create :announcement, event:, active: false

    Announcement.deactivate event
    second_announcement.update active: true

    assert_eq second_announcement.reload.active, true
  end

  test "announcements can be scoped to different events" do
    event1 = create :event, :balkan2025
    event2 = create :event, :balkan2024
    announcement1 = create :announcement, event: event1, active: true
    announcement2 = create :announcement, event: event2, active: true

    # Both announcements can be active since they belong to different events
    assert_eq announcement1.reload.active, true
    assert_eq announcement2.reload.active, true
  end
end
