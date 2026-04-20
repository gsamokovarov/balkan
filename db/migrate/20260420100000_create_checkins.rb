class CreateCheckins < ActiveRecord::Migration[8.0]
  def change
    create_table :checkins do |t|
      t.belongs_to :event, null: false, foreign_key: true
      t.belongs_to :ticket, null: false, foreign_key: true, index: { unique: true }

      t.timestamps
    end
  end
end
