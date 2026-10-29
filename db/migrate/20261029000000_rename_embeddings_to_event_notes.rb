class RenameEmbeddingsToEventNotes < ActiveRecord::Migration[8.0]
  def change
    rename_table :embeddings, :event_notes
  end
end
