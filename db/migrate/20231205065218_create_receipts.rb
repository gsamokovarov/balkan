class CreateReceipts < ActiveRecord::Migration[7.1]
  def change
    create_table :receipts do |t|
      t.belongs_to :order, null: false, foreign_key: true, index: true
      t.belongs_to :invoice, foreign_key: { to_table: :receipts }
      t.integer :number, null: false, index: { unique: true }
      t.integer :variant, null: false, default: 0
      t.date :issue_date, null: false
      t.date :tax_event_date, null: false

      # Receiver details
      t.string :receiver_name, null: false, default: ''
      t.string :receiver_company_uid, null: false, default: ''
      t.string :receiver_company_vat_uid, null: false, default: ''
      t.string :receiver_city, null: false, default: ''
      t.string :receiver_zip, null: false, default: ''
      t.string :receiver_country, null: false, default: '', limit: 3
      t.string :receiver_address, null: false, default: ''
      t.string :receiver_email, null: false, default: ''

      t.timestamps
    end

    create_table :receipt_items do |t|
      t.belongs_to :receipt, null: false, foreign_key: true, index: true
      t.belongs_to :ticket, null: false, foreign_key: true
      t.decimal :amount, null: false
    end
  end
end
