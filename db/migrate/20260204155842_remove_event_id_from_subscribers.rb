class RemoveEventIdFromSubscribers < ActiveRecord::Migration[8.0]
  def change
    remove_reference :subscribers, :event, foreign_key: true
  end
end
