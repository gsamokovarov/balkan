class CreateCommunicationSystem < ActiveRecord::Migration[8.0]
  def change
    # Communication drafts (reusable templates)
    create_table :communication_drafts do |t|
      t.string :name, null: false
      t.text :description
      t.text :subject, null: false
      t.text :content, null: false
      t.integer :event_id
      t.datetime :sent_at

      t.timestamps
    end

    add_index :communication_drafts, :name, unique: true
    add_index :communication_drafts, :event_id

    # Communications (sent campaigns)
    create_table :communications do |t|
      t.integer :event_id, null: false
      t.integer :communication_draft_id, null: false

      t.timestamps
    end

    add_index :communications, :event_id
    add_index :communications, :communication_draft_id
    add_foreign_key :communications, :events
    add_foreign_key :communications, :communication_drafts

    # Communication recipients (join table storing emails)
    create_table :communication_recipients do |t|
      t.integer :communication_id, null: false
      t.string :email, null: false

      t.timestamps
    end

    add_index :communication_recipients, [:communication_id, :email], unique: true
    add_foreign_key :communication_recipients, :communications

    # Add email to speakers
    add_column :speakers, :email, :string
    add_index :speakers, :email
  end
end
