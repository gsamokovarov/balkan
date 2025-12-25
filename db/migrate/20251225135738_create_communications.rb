class CreateCommunications < ActiveRecord::Migration[8.0]
  def change
    create_table :communications do |t|
      t.integer :event_id, null: false
      t.integer :communication_template_id

      t.string :subject, null: false
      t.text :content, null: false

      t.string :status, default: "draft", null: false
      t.datetime :sent_at
      t.text :error_message

      t.timestamps
    end

    add_index :communications, [:event_id, :status]
    add_index :communications, :sent_at
    add_foreign_key :communications, :events
  end
end
