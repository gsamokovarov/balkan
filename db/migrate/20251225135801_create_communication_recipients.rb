class CreateCommunicationRecipients < ActiveRecord::Migration[8.0]
  def change
    create_table :communication_recipients do |t|
      t.integer :communication_id, null: false
      t.string :email, null: false

      t.timestamps
    end

    add_index :communication_recipients, [:communication_id, :email], unique: true
    add_foreign_key :communication_recipients, :communications
  end
end
