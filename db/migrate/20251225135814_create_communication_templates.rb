class CreateCommunicationTemplates < ActiveRecord::Migration[8.0]
  def change
    create_table :communication_templates do |t|
      t.string :name, null: false
      t.text :description
      t.text :subject_template, null: false
      t.text :content_template, null: false

      t.timestamps
    end

    add_index :communication_templates, :name, unique: true
  end
end
