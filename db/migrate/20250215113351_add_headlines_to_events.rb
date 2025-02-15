class AddHeadlinesToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :title, :string
    add_column :events, :subtitle, :string
    add_column :events, :description, :string
  end
end
