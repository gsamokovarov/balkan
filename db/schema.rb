# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_12_01_123553) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string "name", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.string "email", default: "", null: false
    t.string "stripe_checkout_session_uid", default: "", null: false
    t.json "stripe_checkout_session", default: "{}", null: false
    t.datetime "completed_at", precision: nil
    t.datetime "expired_at", precision: nil
    t.boolean "issue_invoice", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "tickets_metadata", default: [], null: false
    t.index ["event_id"], name: "index_orders_on_event_id"
  end

  create_table "ticket_types", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.string "name"
    t.decimal "price", default: "0.0", null: false
    t.boolean "enabled", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_ticket_types_on_event_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.string "description", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.decimal "price", null: false
    t.string "shirt_size", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_tickets_on_order_id"
  end

  add_foreign_key "orders", "events"
  add_foreign_key "ticket_types", "events"
  add_foreign_key "tickets", "orders"
end
