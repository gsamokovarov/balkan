class CreateCommunicationSystem < ActiveRecord::Migration[8.0]
  def change
    create_table :communication_drafts do |t|
      t.belongs_to :event, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.text :subject, null: false
      t.text :content, null: false
      t.datetime :sent_at

      t.timestamps
    end
    add_index :communication_drafts, [:event_id, :name], unique: true

    create_table :communications do |t|
      t.belongs_to :communication_draft, null: false, foreign_key: true

      t.timestamps
    end

    create_table :communication_recipients do |t|
      t.belongs_to :communication, null: false, foreign_key: true
      t.string :email, null: false

      t.timestamps
    end
    add_index :communication_recipients, [:communication_id, :email], unique: true

    add_column :speakers, :email, :string
  end
end

