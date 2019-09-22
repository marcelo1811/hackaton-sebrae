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

ActiveRecord::Schema.define(version: 2019_09_22_050526) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "street"
    t.string "neighborhood"
    t.integer "number"
    t.string "city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "establishment_id"
    t.string "latitude"
    t.string "longitude"
    t.string "state"
    t.string "zip"
    t.index ["establishment_id"], name: "index_addresses_on_establishment_id"
  end

  create_table "emails", force: :cascade do |t|
    t.bigint "establishment_id"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["establishment_id"], name: "index_emails_on_establishment_id"
  end

  create_table "establishments", force: :cascade do |t|
    t.string "fantasy_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cpf_cnpj"
  end

  create_table "observations", force: :cascade do |t|
    t.bigint "establishment_id"
    t.string "content"
    t.bigint "step_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["establishment_id"], name: "index_observations_on_establishment_id"
    t.index ["step_id"], name: "index_observations_on_step_id"
  end

  create_table "phones", force: :cascade do |t|
    t.bigint "establishment_id"
    t.string "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["establishment_id"], name: "index_phones_on_establishment_id"
  end

  create_table "steps", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "whatsapps", force: :cascade do |t|
    t.bigint "establishment_id"
    t.string "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["establishment_id"], name: "index_whatsapps_on_establishment_id"
  end

  add_foreign_key "addresses", "establishments"
  add_foreign_key "emails", "establishments"
  add_foreign_key "observations", "establishments"
  add_foreign_key "observations", "steps"
  add_foreign_key "phones", "establishments"
  add_foreign_key "whatsapps", "establishments"
end
