class AddNameToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :name, :text
  end
end
