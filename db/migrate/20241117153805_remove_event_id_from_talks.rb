class RemoveEventIdFromTalks < ActiveRecord::Migration[7.1]
  def change
    remove_reference :talks, :event, null: false, foreign_key: true
  end
end
