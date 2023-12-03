class RemoveDescriptionFromTicket < ActiveRecord::Migration[7.1]
  def change
    remove_column :tickets, :description, null: false, default: ""
  end
end
