class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.belongs_to :event, null: false, foreign_key: true, index: true
      t.text :message, null: false
      t.boolean :active, null: false, default: false

      t.timestamps
    end

    add_index :notifications, :active, unique: true, where: "active = TRUE"
  end
end
