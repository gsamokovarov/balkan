class AddContactEmailToEvent < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :contact_email, :string
  end
end
