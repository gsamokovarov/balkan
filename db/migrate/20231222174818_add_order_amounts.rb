class AddOrderAmounts < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :amount, :decimal, null: false, default: 0
    add_column :orders, :refunded_amount, :decimal, null: false, default: 0
    remove_column :orders, :refunded_at, :datetime
  end
end
