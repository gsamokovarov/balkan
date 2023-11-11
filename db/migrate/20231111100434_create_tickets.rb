class CreateTickets < ActiveRecord::Migration[7.1]
  def up
    execute <<~SQL
      CREATE TYPE shirt_size AS ENUM ('XS', 'S', 'M', 'L', 'XL', 'XXL');
    SQL

    create_table :tickets do |t|
      t.belongs_to :event, null: false, foreign_key: true, index: true
      t.string :name
      t.column :shirt_size, :shirt_size
      t.boolean :childcare, null: false, default: false
      t.decimal :price, null: false, default: 0.0

      t.timestamps
    end
  end

  def down
    drop_table :tickets
    execute <<~SQL
      DROP TYPE shirt_size;
    SQL
  end
end
