require "rails_helper"

RSpec.case Notification do
  test "activating a notification deactivates all others" do
    event = create :event, :balkan2025
    notification1 = create :notification, event:, active: true
    notification2 = create :notification, event:, active: false

    Notification.activate notification2

    assert_eq notification1.reload.active, false
    assert_eq notification2.reload.active, true
  end

  test "activating a notification works when none are active" do
    event = create :event, :balkan2025
    notification = create :notification, event:, active: false

    Notification.activate notification

    assert_eq notification.reload.active, true
  end

  test "deactivating notifications turns off all active ones" do
    event = create :event, :balkan2025
    notification1 = create :notification, event:, active: true
    notification2 = create :notification, event:, active: false

    Notification.deactivate event

    assert_eq notification1.reload.active, false
    assert_eq notification2.reload.active, false
  end

  test "active returns the currently active notification" do
    event = create :event, :balkan2025
    create :notification, event:, active: false
    active_notification = create :notification, event:, active: true

    assert_eq active_notification, Notification.active_for(event)
  end

  test "active returns nil when no notifications are active" do
    event = create :event, :balkan2025
    create :notification, event:, active: false

    assert_eq nil, Notification.active_for(event)
  end

  test "only one notification can be active at the database level" do
    event = create :event, :balkan2025
    create :notification, event:, active: true
    second_notification = build :notification, event:, active: true

    assert_raise_error ActiveRecord::RecordNotUnique do
      second_notification.save! validate: false
    end
  end

  test "allows multiple inactive notifications" do
    event = create :event, :balkan2025
    create :notification, event:, active: false
    second_notification = build :notification, event:, active: false

    second_notification.save!

    assert_eq second_notification.persisted?, true
  end

  test "allows activating a new notification after deactivating others" do
    event = create :event, :balkan2025
    create :notification, event:, active: true
    second_notification = create :notification, event:, active: false

    Notification.deactivate event
    second_notification.update active: true

    assert_eq second_notification.reload.active, true
  end

  test "notifications can be scoped to different events" do
    event1 = create :event, :balkan2025
    event2 = create :event, :balkan2024
    notification1 = create :notification, event: event1, active: true
    notification2 = create :notification, event: event2, active: true

    # Both notifications can be active since they belong to different events
    assert_eq notification1.reload.active, true
    assert_eq notification2.reload.active, true
  end
end
