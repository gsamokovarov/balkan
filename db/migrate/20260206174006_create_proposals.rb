class CreateProposals < ActiveRecord::Migration[8.0]
  def change
    create_table :proposals do |t|
      t.belongs_to :event, null: false, foreign_key: true

      t.string :name, null: false
      t.string :email, null: false
      t.text :bio
      t.string :social_url

      t.string :title, null: false
      t.text :description

      t.timestamps
    end
  end
end
