class AddRoleToLineupMember < ActiveRecord::Migration[7.1]
  def change
    add_column :lineup_members, :role, :string, default: "Speaker"
  end
end
