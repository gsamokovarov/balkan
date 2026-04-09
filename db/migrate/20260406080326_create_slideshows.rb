class CreateSlideshows < ActiveRecord::Migration[8.0]
  def change
    create_table :slideshows do |t|
      t.belongs_to :event, null: false, foreign_key: true, index: { unique: true }
      t.text :content, null: false

      t.timestamps
    end
  end
end
