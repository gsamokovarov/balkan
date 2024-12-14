class CreateAdminEmbedding < ActiveRecord::Migration[7.1]
  def change
    create_table :embeddings do |t|
      t.references :event, null: false, foreign_key: true
      t.string :name, null: false
      t.string :description
      t.string :url, null: false

      t.timestamps
    end
  end
end
