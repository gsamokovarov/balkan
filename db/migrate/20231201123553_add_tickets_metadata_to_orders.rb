class AddTicketsMetadataToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :tickets_metadata, :json, default: [], null: false
  end
end
