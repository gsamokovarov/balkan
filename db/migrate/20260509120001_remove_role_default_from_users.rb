class RemoveRoleDefaultFromUsers < ActiveRecord::Migration[8.0]
  def change
    change_column_default :users, :role, from: 1, to: nil
  end
end
