class AddHostToEvent < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :host, :string
  end
end
