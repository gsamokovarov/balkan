class CreateSlideshows < ActiveRecord::Migration[8.0]
  def change
    create_table :slideshows do |t|
      t.string :content

      t.timestamps
    end
  end
end
