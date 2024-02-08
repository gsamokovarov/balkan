class CreateInvoiceSequence < ActiveRecord::Migration[7.1]
  def change
    create_table :invoice_sequences do |t|
      t.integer :initial_number, null: false
      t.belongs_to :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
