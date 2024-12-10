class CreateSchedule < ActiveRecord::Migration[7.1]
  def change
    create_table :schedules do |t|
      t.belongs_to :event, null: false, foreign_key: true, index: { unique: true }
      t.timestamp :published_at
      t.timestamps
    end

    create_table :schedule_slots do |t|
      t.belongs_to :schedule, null: false, foreign_key: true
      t.belongs_to :lineup_member, foreign_key: true
      t.date :date, null: false
      t.datetime :time, null: false
      t.string :description, null: false
      t.timestamps
    end
  end
end
