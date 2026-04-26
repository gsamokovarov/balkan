class AddWithSponsorsToCommunications < ActiveRecord::Migration[8.0]
  def change
    add_column :communications, :with_sponsors, :boolean, default: false, null: false
  end
end
