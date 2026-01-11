class AddNameToInvoiceSequences < ActiveRecord::Migration[8.0]
  def change
    add_column :invoice_sequences, :name, :string
  end
end
