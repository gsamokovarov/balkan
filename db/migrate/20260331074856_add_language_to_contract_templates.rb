class AddLanguageToContractTemplates < ActiveRecord::Migration[8.0]
  def change
    add_column :contract_templates, :language, :string, default: "en", null: false
  end
end
