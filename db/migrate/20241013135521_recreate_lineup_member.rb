class RecreateLineupMember < ActiveRecord::Migration[7.1]
  def change
    drop_table :lineup_members

    create_table :lineup_members do |t|
      t.belongs_to :event, null: false, foreign_key: true
      t.belongs_to :speaker, null: false, foreign_key: true
      t.belongs_to :talk, foreign_key: true
      t.boolean :announced, null: false, default: false

      t.timestamps
    end
  end
end
