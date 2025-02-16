class AddSocialUrlsToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :twitter_url, :string
    add_column :events, :facebook_url, :string
    add_column :events, :youtube_url, :string
  end
end
