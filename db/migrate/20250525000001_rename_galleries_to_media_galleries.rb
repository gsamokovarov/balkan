class RenameGalleriesToMediaGalleries < ActiveRecord::Migration[8.0]
  def change
    rename_table :galleries, :media_galleries
  end
end
