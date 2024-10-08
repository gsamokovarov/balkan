class EventIndependentInvoiceSequence < ActiveRecord::Migration[7.1]
  def change
    remove_column :invoice_sequences, :event_id
    add_reference :events, :invoice_sequence, null: true, foreign_key: true
  end
end
