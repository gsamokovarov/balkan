class CreateContractTemplates < ActiveRecord::Migration[8.0]
  def change
    create_table :contract_templates do |t|
      t.references :event, null: false, foreign_key: true
      t.string :name, null: false
      t.text :content, null: false

      t.timestamps
    end
  end
end
