class AddDescriptionToTicketTypes < ActiveRecord::Migration[8.0]
  def change
    add_column :ticket_types, :description, :text
  end
end
