class CreateContracts < ActiveRecord::Migration[8.0]
  def change
    create_table :contracts do |t|
      t.references :event, null: false, foreign_key: true
      t.references :contract_template, null: false, foreign_key: true
      t.date :agreement_date
      t.date :payment_deadline
      t.date :materials_deadline
      t.decimal :price
      t.string :company_name
      t.string :company_address
      t.string :company_country
      t.string :company_id_number
      t.string :company_vat_id
      t.string :representative_name
      t.text :perks

      t.timestamps
    end
  end
end
