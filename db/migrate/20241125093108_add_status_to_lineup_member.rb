class AddStatusToLineupMember < ActiveRecord::Migration[7.1]
  def change
    add_column :lineup_members, :status, :integer, null: false, default: 0
  end
end
