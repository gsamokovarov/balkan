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

ActiveRecord::Schema[8.0].define(version: 2025_12_25_135738) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "announcements", force: :cascade do |t|
    t.integer "event_id", null: false
    t.text "message", null: false
    t.boolean "active", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id", "active"], name: "index_announcements_on_event_id_and_active", unique: true, where: "active = true"
    t.index ["event_id"], name: "index_announcements_on_event_id"
  end

  create_table "blog_posts", force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "author_id", null: false
    t.date "date"
    t.string "title"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "published_at"
    t.index ["author_id"], name: "index_blog_posts_on_author_id"
    t.index ["event_id"], name: "index_blog_posts_on_event_id"
  end

  create_table "communication_drafts", force: :cascade do |t|
    t.integer "event_id", null: false
    t.string "name", null: false
    t.text "subject", null: false
    t.text "content", null: false
    t.datetime "sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id", "name"], name: "index_communication_drafts_on_event_id_and_name", unique: true
    t.index ["event_id"], name: "index_communication_drafts_on_event_id"
  end

  create_table "communication_recipients", force: :cascade do |t|
    t.integer "communication_id", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["communication_id", "email"], name: "index_communication_recipients_on_communication_id_and_email", unique: true
    t.index ["communication_id"], name: "index_communication_recipients_on_communication_id"
  end

  create_table "communications", force: :cascade do |t|
    t.integer "communication_draft_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["communication_draft_id"], name: "index_communications_on_communication_draft_id"
  end

  create_table "community_partners", force: :cascade do |t|
    t.integer "event_id", null: false
    t.string "name", null: false
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_community_partners_on_event_id"
  end

  create_table "embeddings", force: :cascade do |t|
    t.integer "event_id", null: false
    t.string "name", null: false
    t.string "description"
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_embeddings_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "speaker_applications_end_date", default: "2024-02-02", null: false
    t.integer "invoice_sequence_id"
    t.string "host"
    t.integer "venue_id"
    t.string "title"
    t.string "subtitle"
    t.string "description"
    t.string "contact_email"
    t.string "twitter_url"
    t.string "facebook_url"
    t.string "youtube_url"
    t.string "speaker_applications_url"
    t.index ["invoice_sequence_id"], name: "index_events_on_invoice_sequence_id"
    t.index ["venue_id"], name: "index_events_on_venue_id"
  end

  create_table "invoice_sequences", force: :cascade do |t|
    t.integer "initial_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "lineup_members", force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "speaker_id", null: false
    t.integer "talk_id"
    t.boolean "announced", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", default: "Speaker"
    t.integer "status", default: 0, null: false
    t.index ["event_id"], name: "index_lineup_members_on_event_id"
    t.index ["speaker_id"], name: "index_lineup_members_on_speaker_id"
    t.index ["talk_id"], name: "index_lineup_members_on_talk_id"
  end

  create_table "media_galleries", force: :cascade do |t|
    t.integer "event_id", null: false
    t.string "title"
    t.string "videos_url", null: false
    t.string "photos_url"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "video1_url"
    t.string "video2_url"
    t.string "video3_url"
    t.string "video4_url"
    t.index ["event_id"], name: "index_media_galleries_on_event_id", unique: true
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

  create_table "schedule_slots", force: :cascade do |t|
    t.integer "schedule_id", null: false
    t.integer "lineup_member_id"
    t.date "date", null: false
    t.datetime "time", null: false
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lineup_member_id"], name: "index_schedule_slots_on_lineup_member_id"
    t.index ["schedule_id"], name: "index_schedule_slots_on_schedule_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.integer "event_id", null: false
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_schedules_on_event_id", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "speakers", force: :cascade do |t|
    t.string "name", null: false
    t.string "bio"
    t.string "github_url"
    t.string "social_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
  end

  create_table "speakers_talks", id: false, force: :cascade do |t|
    t.integer "talk_id", null: false
    t.integer "speaker_id", null: false
    t.index ["speaker_id"], name: "index_speakers_talks_on_speaker_id"
    t.index ["talk_id"], name: "index_speakers_talks_on_talk_id"
  end

  create_table "sponsors", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sponsorship_packages", force: :cascade do |t|
    t.integer "event_id", null: false
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_sponsorship_packages_on_event_id"
  end

  create_table "sponsorship_variants", force: :cascade do |t|
    t.integer "package_id", null: false
    t.string "name", null: false
    t.decimal "price", null: false
    t.integer "quantity"
    t.string "perks", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["package_id"], name: "index_sponsorship_variants_on_package_id"
  end

  create_table "sponsorships", force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "sponsor_id", null: false
    t.integer "variant_id", null: false
    t.decimal "price_paid", null: false
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_sponsorships_on_event_id"
    t.index ["sponsor_id"], name: "index_sponsorships_on_sponsor_id"
    t.index ["variant_id"], name: "index_sponsorships_on_variant_id"
  end

  create_table "subscribers", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.text "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_subscribers_on_email", unique: true
    t.index ["event_id"], name: "index_subscribers_on_event_id"
  end

  create_table "talks", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "video_url"
  end

  create_table "ticket_types", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.string "name"
    t.decimal "price", default: "0.0", null: false
    t.boolean "enabled", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
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

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "bio"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "venues", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.string "address"
    t.string "directions"
    t.string "place_id"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "announcements", "events"
  add_foreign_key "blog_posts", "events"
  add_foreign_key "blog_posts", "users", column: "author_id"
  add_foreign_key "communication_drafts", "events"
  add_foreign_key "communication_recipients", "communications"
  add_foreign_key "communications", "communication_drafts"
  add_foreign_key "community_partners", "events"
  add_foreign_key "embeddings", "events"
  add_foreign_key "events", "invoice_sequences"
  add_foreign_key "events", "venues"
  add_foreign_key "invoices", "invoice_sequences"
  add_foreign_key "invoices", "orders"
  add_foreign_key "lineup_members", "events"
  add_foreign_key "lineup_members", "speakers"
  add_foreign_key "lineup_members", "talks"
  add_foreign_key "media_galleries", "events"
  add_foreign_key "orders", "events"
  add_foreign_key "schedule_slots", "lineup_members"
  add_foreign_key "schedule_slots", "schedules"
  add_foreign_key "schedules", "events"
  add_foreign_key "sessions", "users"
  add_foreign_key "sponsorship_packages", "events"
  add_foreign_key "sponsorship_variants", "sponsorship_packages", column: "package_id"
  add_foreign_key "sponsorships", "events"
  add_foreign_key "sponsorships", "sponsors"
  add_foreign_key "sponsorships", "sponsorship_variants", column: "variant_id"
  add_foreign_key "subscribers", "events"
  add_foreign_key "ticket_types", "events"
  add_foreign_key "tickets", "orders"
  add_foreign_key "tickets", "ticket_types"
end
