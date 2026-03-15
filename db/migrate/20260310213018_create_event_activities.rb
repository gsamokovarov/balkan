class CreateEventActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :event_activities do |t|
      t.belongs_to :event, null: false, foreign_key: true
      t.text :content
      t.datetime :published_at

      t.timestamps
    end
  end
end
