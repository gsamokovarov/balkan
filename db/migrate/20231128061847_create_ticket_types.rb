class CreateTicketTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :ticket_types do |t|
      t.belongs_to :event, null: false, foreign_key: true, index: true
      t.string :name
      t.decimal :price, null: false, default: 0.0
      t.boolean :enabled, null: false, default: false

      t.timestamps
    end
  end
end
