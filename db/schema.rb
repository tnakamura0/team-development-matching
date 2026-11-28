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

ActiveRecord::Schema[8.1].define(version: 2026_11_24_130123) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "applications", force: :cascade do |t|
    t.bigint "recruitment_id", null: false
    t.bigint "user_id", null: false
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recruitment_id"], name: "index_applications_on_recruitment_id"
    t.index ["user_id", "recruitment_id"], name: "index_applications_on_user_id_and_recruitment_id", unique: true
    t.index ["user_id"], name: "index_applications_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "recipient_id", null: false
    t.bigint "application_id", null: false
    t.string "action", null: false
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id", "action"], name: "index_notifications_on_application_id_and_action", unique: true
    t.index ["recipient_id", "created_at"], name: "index_notifications_on_recipient_id_and_created_at"
  end

  create_table "recruitments", force: :cascade do |t|
    t.string "title", null: false
    t.text "body"
    t.date "closing_date", null: false
    t.integer "positions_count", null: false
    t.string "required_status", null: false
    t.boolean "accepting_applications", default: true, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_recruitments_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.integer "period", null: false
    t.string "required_status", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "applications", "recruitments"
  add_foreign_key "applications", "users"
  add_foreign_key "notifications", "applications"
  add_foreign_key "notifications", "users", column: "recipient_id"
  add_foreign_key "recruitments", "users"
  add_foreign_key "sessions", "users"
end
