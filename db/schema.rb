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

ActiveRecord::Schema[7.0].define(version: 2022_11_23_202335) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "links", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "url"
    t.bigint "timestamp"
    t.text "token"
    t.bigint "visits"
    t.datetime "last_visit"
    t.text "creator_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_ip"], name: "index_links_on_creator_ip"
    t.index ["last_visit"], name: "index_links_on_last_visit"
    t.index ["timestamp"], name: "index_links_on_timestamp"
    t.index ["token"], name: "index_links_on_token"
    t.index ["url", "timestamp", "token"], name: "links_are_unique", unique: true
    t.index ["url"], name: "index_links_on_url"
    t.index ["visits"], name: "index_links_on_visits"
  end

end
