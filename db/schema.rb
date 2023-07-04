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

ActiveRecord::Schema[7.0].define(version: 2023_07_04_191618) do
  create_table "campaigns", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_campaigns_on_name", unique: true
  end

  create_table "candidates", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "campaign_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_name"], name: "fk_rails_bc717dd87b"
  end

  create_table "votes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "campaign_name", null: false
    t.bigint "candidate_id", null: false
    t.string "validity", null: false
    t.datetime "voted_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_name"], name: "fk_rails_dcaa1bd05d"
    t.index ["candidate_id"], name: "index_votes_on_candidate_id"
  end

  add_foreign_key "candidates", "campaigns", column: "campaign_name", primary_key: "name"
  add_foreign_key "votes", "campaigns", column: "campaign_name", primary_key: "name"
  add_foreign_key "votes", "candidates"
end
