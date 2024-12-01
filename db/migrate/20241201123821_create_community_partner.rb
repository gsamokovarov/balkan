class CreateCommunityPartner < ActiveRecord::Migration[7.1]
  def change
    create_table :community_partners do |t|
      t.belongs_to :event, null: false, foreign_key: true
      t.string :name, null: false
      t.string :url, null: false

      t.timestamps
    end
  end
end
