class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.belongs_to :event, null: false, foreign_key: true, index: true
      t.string :email, null: false, default: ""
      t.string :stripe_checkout_session_uid, null: false, default: ""
      t.json :stripe_checkout_session, null: false, default: "{}"
      t.timestamp :completed_at
      t.timestamp :expired_at
      t.boolean :issue_invoice, default: false, null: false

      t.timestamps
    end
  end
end
