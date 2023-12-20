class CreateSubscribers < ActiveRecord::Migration[7.1]
  def change
    create_table :subscribers do |t|
      t.belongs_to :event, null: false, foreign_key: true
      t.text :email, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
