class FixTalksEventRelation < ActiveRecord::Migration[7.1]
  def change
    remove_column :talks, :event_id_id
    add_belongs_to :talks, :event, null: false, foreign_key: true
  end
end
