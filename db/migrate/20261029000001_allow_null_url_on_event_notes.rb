class AllowNullUrlOnEventNotes < ActiveRecord::Migration[8.0]
  def change
    change_column_null :event_notes, :url, true, ""
  end
end
