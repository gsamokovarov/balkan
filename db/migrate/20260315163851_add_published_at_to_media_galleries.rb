class AddPublishedAtToMediaGalleries < ActiveRecord::Migration[8.0]
  def change
    add_column :media_galleries, :published_at, :datetime
  end
end
