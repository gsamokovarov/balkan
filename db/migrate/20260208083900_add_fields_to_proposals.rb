class AddFieldsToProposals < ActiveRecord::Migration[8.0]
  def change
    add_column :proposals, :location, :string
    add_column :proposals, :company, :string
    add_column :proposals, :github_url, :string
    add_column :proposals, :notes, :text
  end
end
