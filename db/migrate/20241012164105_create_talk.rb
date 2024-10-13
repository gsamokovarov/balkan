class CreateTalk < ActiveRecord::Migration[7.1]
  def change
    create_table :talks do |t|
      t.belongs_to :event_id, foreign_key: true, index: true
      t.string :name, null: false
      t.string :description

      t.timestamps
    end

    create_join_table :talks, :speakers do |t|
      t.index :talk_id
      t.index :speaker_id
    end
  end
end
