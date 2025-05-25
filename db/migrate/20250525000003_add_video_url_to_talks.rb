class AddVideoUrlToTalks < ActiveRecord::Migration[8.0]
  def change
    add_column :talks, :video_url, :string
  end
end
