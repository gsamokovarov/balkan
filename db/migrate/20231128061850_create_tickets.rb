class CreateTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :tickets do |t|
      t.belongs_to :order, null: false, foreign_key: true, index: true
      t.string :description, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.decimal :price, null: false
      t.string :shirt_size, null: false

      t.timestamps
    end
  end
end
