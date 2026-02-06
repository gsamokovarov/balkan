class AddLikedToProposals < ActiveRecord::Migration[8.0]
  def change
    add_column :proposals, :liked, :boolean, default: false
  end
end
