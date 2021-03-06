# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171105182630) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pgcrypto"
  enable_extension "pg_trgm"

  create_table "doctors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_doctors_on_confirmation_token", unique: true
    t.index ["email"], name: "index_doctors_on_email", unique: true
    t.index ["reset_password_token"], name: "index_doctors_on_reset_password_token", unique: true
  end

  create_table "medical_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.text "notes"
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "prescriptions_count", default: 0, null: false
    t.index ["name"], name: "index_medical_records_on_name", unique: true
    t.index ["user_id"], name: "index_medical_records_on_user_id"
  end

  create_table "notifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "sender_type"
    t.uuid "sender_id"
    t.string "recepient_type"
    t.uuid "recepient_id"
    t.string "action", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "medical_record_id"
    t.uuid "share_record_id"
    t.index ["medical_record_id"], name: "index_notifications_on_medical_record_id"
    t.index ["recepient_type", "recepient_id"], name: "index_notifications_on_recepient_type_and_recepient_id"
    t.index ["sender_type", "sender_id"], name: "index_notifications_on_sender_type_and_sender_id"
    t.index ["share_record_id"], name: "index_notifications_on_share_record_id"
  end

  create_table "pharmacists", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_pharmacists_on_confirmation_token", unique: true
    t.index ["email"], name: "index_pharmacists_on_email", unique: true
    t.index ["reset_password_token"], name: "index_pharmacists_on_reset_password_token", unique: true
  end

  create_table "prescriptions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "dosage", default: "", null: false
    t.string "dosage_unit", default: "", null: false
    t.boolean "morning", default: false, null: false
    t.boolean "afternoon", default: false, null: false
    t.boolean "night", default: false, null: false
    t.string "time", default: "", null: false
    t.uuid "medical_record_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medical_record_id"], name: "index_prescriptions_on_medical_record_id"
  end

  create_table "share_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "shared", default: false, null: false
    t.uuid "user_id"
    t.uuid "medical_record_id"
    t.string "shareable_type"
    t.uuid "shareable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "created_by"
    t.string "action"
    t.index ["medical_record_id"], name: "index_share_records_on_medical_record_id"
    t.index ["shareable_type", "shareable_id"], name: "index_share_records_on_shareable_type_and_shareable_id"
    t.index ["shared"], name: "index_share_records_on_shared", where: "shared"
    t.index ["user_id"], name: "index_share_records_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "medical_records_count", default: 0, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "medical_records", "users"
  add_foreign_key "notifications", "medical_records"
  add_foreign_key "notifications", "share_records"
  add_foreign_key "prescriptions", "medical_records"
  add_foreign_key "share_records", "medical_records"
  add_foreign_key "share_records", "users"
end
