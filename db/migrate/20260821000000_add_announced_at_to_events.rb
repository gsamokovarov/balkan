class AddAnnouncedAtToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :announced_at, :datetime
  end
end
