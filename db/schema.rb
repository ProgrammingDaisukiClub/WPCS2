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

ActiveRecord::Schema.define(version: 20170508110039) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_roles", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_admin_roles_on_user_id", unique: true
  end

  create_table "contest_registrations", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "contest_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contest_id"], name: "index_contest_registrations_on_contest_id"
    t.index ["user_id"], name: "index_contest_registrations_on_user_id"
  end

  create_table "contests", id: :serial, force: :cascade do |t|
    t.string "name_ja", null: false
    t.string "name_en", null: false
    t.string "description_ja", null: false
    t.string "description_en", null: false
    t.datetime "start_at", null: false
    t.datetime "end_at", null: false
    t.float "score_baseline", null: false
    t.integer "status"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "data_sets", id: :serial, force: :cascade do |t|
    t.integer "problem_id", null: false
    t.string "label"
    t.text "input", null: false
    t.text "output", null: false
    t.integer "score", null: false
    t.integer "accuracy", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order", null: false
    t.index ["problem_id"], name: "index_data_sets_on_problem_id"
  end

  create_table "editorials", id: :serial, force: :cascade do |t|
    t.integer "contest_id"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "problems", id: :serial, force: :cascade do |t|
    t.integer "contest_id", null: false
    t.string "name_ja", null: false
    t.string "name_en", null: false
    t.string "description_ja", null: false
    t.string "description_en", null: false
    t.integer "order", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contest_id"], name: "index_problems_on_contest_id"
  end

  create_table "submissions", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "data_set_id", null: false
    t.text "answer", null: false
    t.text "code"
    t.integer "language"
    t.integer "judge_status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "score"
    t.index ["data_set_id"], name: "index_submissions_on_data_set_id"
    t.index ["user_id"], name: "index_submissions_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "admin_roles", "users"
  add_foreign_key "contest_registrations", "contests"
  add_foreign_key "contest_registrations", "users"
  add_foreign_key "data_sets", "problems"
  add_foreign_key "problems", "contests"
  add_foreign_key "submissions", "data_sets"
  add_foreign_key "submissions", "users"
end
