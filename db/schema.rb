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

ActiveRecord::Schema[7.1].define(version: 2024_03_27_131937) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string "name", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "speaker_applications_end_date", default: "2024-02-02", null: false
  end

  create_table "invoice_sequences", force: :cascade do |t|
    t.integer "initial_number", null: false
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_invoice_sequences_on_event_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "invoice_sequence_id", null: false
    t.integer "number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "customer_name"
    t.string "customer_address"
    t.string "customer_country"
    t.string "customer_vat_id"
    t.index ["invoice_sequence_id"], name: "index_invoices_on_invoice_sequence_id"
    t.index ["order_id"], name: "index_invoices_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.string "email", default: "", null: false
    t.string "stripe_checkout_session_uid", default: "", null: false
    t.json "stripe_checkout_session"
    t.datetime "completed_at", precision: nil
    t.datetime "expired_at", precision: nil
    t.boolean "issue_invoice", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "pending_tickets", default: [], null: false
    t.decimal "amount", default: "0.0", null: false
    t.decimal "refunded_amount", default: "0.0", null: false
    t.boolean "free", default: false, null: false
    t.text "free_reason"
    t.text "name"
    t.index ["event_id"], name: "index_orders_on_event_id"
  end

  create_table "subscribers", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.text "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_subscribers_on_email", unique: true
    t.index ["event_id"], name: "index_subscribers_on_event_id"
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
    t.string "name", null: false
    t.string "email", null: false
    t.decimal "price", null: false
    t.string "shirt_size", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "ticket_type_id"
    t.index ["order_id"], name: "index_tickets_on_order_id"
    t.index ["ticket_type_id"], name: "index_tickets_on_ticket_type_id"
  end

  add_foreign_key "invoice_sequences", "events"
  add_foreign_key "invoices", "invoice_sequences"
  add_foreign_key "invoices", "orders"
  add_foreign_key "orders", "events"
  add_foreign_key "subscribers", "events"
  add_foreign_key "ticket_types", "events"
  add_foreign_key "tickets", "orders"
  add_foreign_key "tickets", "ticket_types"
end
