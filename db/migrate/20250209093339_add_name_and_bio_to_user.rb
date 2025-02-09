class AddNameAndBioToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :bio, :string
  end
end
