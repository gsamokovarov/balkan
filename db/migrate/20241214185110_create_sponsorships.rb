class CreateSponsorships < ActiveRecord::Migration[7.1]
  def change
    create_table :sponsors do |t|
      t.string :name, null: false
      t.string :description
      t.string :url

      t.timestamps
    end

    create_table :sponsorship_packages do |t|
      t.belongs_to :event, null: false, foreign_key: true
      t.string :name, null: false
      t.string :description

      t.timestamps
    end

    create_table :sponsorship_variants do |t|
      t.belongs_to :package, null: false, foreign_key: { to_table: :sponsorship_packages }
      t.string :name, null: false
      t.decimal :price, null: false
      t.integer :quantity
      t.string :perks, null: false

      t.timestamps
    end

    create_table :sponsorships do |t|
      t.belongs_to :event, null: false, foreign_key: true
      t.belongs_to :sponsor, null: false, foreign_key: true
      t.belongs_to :variant, null: false, foreign_key: { to_table: :sponsorship_variants }
      t.decimal :price_paid, null: false
      t.string :reason

      t.timestamps
    end
  end
end
