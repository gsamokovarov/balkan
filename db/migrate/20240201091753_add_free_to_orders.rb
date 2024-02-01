class AddFreeToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :free, :boolean, null: false, default: false
    add_column :orders, :free_reason, :text, null: true
  end
end
