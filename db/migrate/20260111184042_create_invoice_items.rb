class CreateInvoiceItems < ActiveRecord::Migration[8.0]
  def change
    create_table :invoice_items do |t|
      t.references :invoice, null: false, foreign_key: true
      t.string :description_en
      t.string :description_bg
      t.decimal :unit_price

      t.timestamps
    end
  end
end
