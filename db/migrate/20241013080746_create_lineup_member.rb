class CreateLineupMember < ActiveRecord::Migration[7.1]
  def change
    create_table :lineup_members do |t|
      t.belongs_to :event_id, null: false, foreign_key: true
      t.belongs_to :speaker_id, null: false, foreign_key: true
      t.belongs_to :talk_id, foreign_key: true
      t.boolean :announced, null: false, default: false

      t.timestamps
    end
  end
end
