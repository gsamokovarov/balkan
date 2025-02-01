class CreateVenue < ActiveRecord::Migration[8.0]
  def change
    create_table :venues do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.string :address
      t.string :directions
      t.string :place_id
      t.string :url

      t.timestamps
    end

    add_reference :events, :venue, foreign_key: true
  end
end
