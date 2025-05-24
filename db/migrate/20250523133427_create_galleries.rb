class CreateGalleries < ActiveRecord::Migration[8.0]
  def change
    create_table :galleries do |t|
      t.belongs_to :event, null: false, foreign_key: true, index: { unique: true }
      t.string :title
      t.string :videos_url, null: false
      t.string :photos_url
      t.text :description

      t.timestamps
    end
  end
end
