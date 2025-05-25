class AddYoutubeVideosToMediaGalleries < ActiveRecord::Migration[8.0]
  def change
    add_column :media_galleries, :video1_url, :string
    add_column :media_galleries, :video2_url, :string
    add_column :media_galleries, :video3_url, :string
    add_column :media_galleries, :video4_url, :string
  end
end
