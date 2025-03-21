class RenameNotificationToAnnouncement < ActiveRecord::Migration[8.0]
  def up
    remove_index :notifications, [:event_id, :active] if index_exists?(:notifications, [:event_id, :active])
    rename_table :notifications, :announcements
    if index_exists?(:announcements, :event_id)
      rename_index :announcements, "index_notifications_on_event_id", "index_announcements_on_event_id"
    end
    add_index :announcements, [:event_id, :active], unique: true, where: "active = true"
  end

  def down
    remove_index :announcements, [:event_id, :active] if index_exists?(:announcements, [:event_id, :active])
    rename_table :announcements, :notifications
    if index_exists?(:notifications, :event_id)
      rename_index :notifications, "index_announcements_on_event_id", "index_notifications_on_event_id"
    end
    add_index :notifications, [:event_id, :active], unique: true, where: "active = true"
  end
end
