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

ActiveRecord::Schema[8.1].define(version: 2026_05_13_033640) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "asset_logs", force: :cascade do |t|
    t.string "action", null: false
    t.bigint "asset_id", null: false
    t.datetime "created_at", null: false
    t.bigint "location_id", null: false
    t.text "remarks"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["asset_id"], name: "index_asset_logs_on_asset_id"
    t.index ["location_id"], name: "index_asset_logs_on_location_id"
    t.index ["user_id"], name: "index_asset_logs_on_user_id"
  end

  create_table "assets", force: :cascade do |t|
    t.decimal "acquisition_cost", precision: 15, scale: 2, default: "0.0"
    t.string "asset_code", null: false
    t.string "asset_image_url"
    t.string "asset_type"
    t.date "buy_date"
    t.datetime "created_at", null: false
    t.bigint "current_holder_id"
    t.string "description"
    t.bigint "location_id", null: false
    t.string "name", null: false
    t.text "notes"
    t.text "remarks"
    t.decimal "salvage_value", precision: 15, scale: 2, default: "0.0"
    t.string "serial_number"
    t.string "status", default: "active"
    t.date "tax_date"
    t.datetime "updated_at", null: false
    t.integer "useful_life"
    t.index ["asset_code"], name: "index_assets_on_asset_code", unique: true
    t.index ["current_holder_id"], name: "index_assets_on_current_holder_id"
    t.index ["location_id"], name: "index_assets_on_location_id"
    t.index ["serial_number"], name: "index_assets_on_serial_number", unique: true
  end

  create_table "locations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "first_name"
    t.string "full_name"
    t.string "last_name"
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "asset_logs", "assets"
  add_foreign_key "asset_logs", "locations"
  add_foreign_key "asset_logs", "users"
  add_foreign_key "assets", "locations"
  add_foreign_key "assets", "users", column: "current_holder_id"
end
