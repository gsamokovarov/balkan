class CreateSingleNotificationPerEventIndex < ActiveRecord::Migration[8.0]
  def change
    remove_index :notifications, :active, unique: true, where: "active = TRUE"
    add_index :notifications, [:event_id, :active], unique: true, where: "active = true"
  end
end
