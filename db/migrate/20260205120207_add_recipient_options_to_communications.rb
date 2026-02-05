class AddRecipientOptionsToCommunications < ActiveRecord::Migration[8.0]
  def change
    add_column :communications, :to_subscribers, :boolean, default: false, null: false
    add_column :communications, :to_event, :boolean, default: false, null: false
    add_column :communications, :to_speakers, :boolean, default: false, null: false
  end
end
