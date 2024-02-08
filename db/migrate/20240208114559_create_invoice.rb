class CreateInvoice < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices do |t|
      t.belongs_to :order, null: false, foreign_key: true
      t.belongs_to :invoice_sequence, null: false, foreign_key: true
      t.integer :number, null: false

      t.timestamps
    end
  end
end
