class AddEmailToSpeakers < ActiveRecord::Migration[8.0]
  def change
    add_column :speakers, :email, :string
    add_index :speakers, :email
  end
end
