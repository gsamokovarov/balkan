class AddStatusToProposals < ActiveRecord::Migration[8.0]
  def change
    add_column :proposals, :status, :integer, default: 0
  end
end
