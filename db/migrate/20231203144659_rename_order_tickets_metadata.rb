class RenameOrderTicketsMetadata < ActiveRecord::Migration[7.1]
  def change
    rename_column :orders, :tickets_metadata, :pending_tickets
  end
end
