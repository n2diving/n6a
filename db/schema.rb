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

ActiveRecord::Schema.define(version: 20170326224746) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "employee_reviewers", force: :cascade do |t|
    t.integer  "employee_user_id"
    t.integer  "reviewer_user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "employee_teams", force: :cascade do |t|
    t.integer  "user_id"
    t.boolean  "team_lead",  default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "team_id"
    t.date     "start_date"
    t.date     "end_date"
    t.index ["team_id"], name: "index_employee_teams_on_team_id", using: :btree
    t.index ["user_id"], name: "index_employee_teams_on_user_id", using: :btree
  end

  create_table "form_roles", force: :cascade do |t|
    t.string   "role"
    t.string   "abbreviation"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "review_items", force: :cascade do |t|
    t.string   "name"
    t.string   "display_name"
    t.text     "evaluation_criteria"
    t.integer  "scale_min"
    t.integer  "scale_max"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "response_allowed",    default: false
    t.boolean  "is_team",             default: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "is_weekly",           default: false
    t.boolean  "is_monthly_bonus",    default: false
    t.float    "bonus_amount"
  end

  create_table "review_items_by_roles", force: :cascade do |t|
    t.integer "review_item_id"
    t.string  "short_label"
    t.text    "evaluation_criteria"
    t.integer "form_role_id"
    t.index ["form_role_id"], name: "index_review_items_by_roles_on_form_role_id", using: :btree
    t.index ["review_item_id"], name: "index_review_items_by_roles_on_review_item_id", using: :btree
  end

  create_table "review_notes", force: :cascade do |t|
    t.integer  "user_review_id"
    t.text     "general_notes"
    t.text     "pros"
    t.text     "cons"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["user_review_id"], name: "index_review_notes_on_user_review_id", using: :btree
  end

  create_table "team_of_the_months", force: :cascade do |t|
    t.string   "name"
    t.date     "rate_period"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string   "team_name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "is_hidden"
  end

  create_table "user_reviews", force: :cascade do |t|
    t.integer  "review_item_id"
    t.integer  "user_id"
    t.decimal  "rating",                  precision: 3, scale: 1
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
    t.integer  "rated_by_user_id"
    t.boolean  "notes_allowed",                                   default: false
    t.date     "rate_period"
    t.boolean  "is_team",                                         default: false
    t.text     "pros"
    t.text     "cons"
    t.text     "notes"
    t.integer  "review_items_by_role_id"
    t.boolean  "is_archived",                                     default: false
    t.boolean  "checked",                                         default: false
    t.integer  "multiplier"
    t.integer  "team_id"
    t.index ["review_item_id"], name: "index_user_reviews_on_review_item_id", using: :btree
    t.index ["review_items_by_role_id"], name: "index_user_reviews_on_review_items_by_role_id", using: :btree
    t.index ["user_id"], name: "index_user_reviews_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.datetime "start_date"
    t.boolean  "is_current",             default: true
    t.string   "title"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "is_officer",             default: false
    t.boolean  "is_admin",               default: false
    t.integer  "form_role_id"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["form_role_id"], name: "index_users_on_form_role_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "employee_teams", "teams"
  add_foreign_key "employee_teams", "users"
  add_foreign_key "review_items_by_roles", "form_roles"
  add_foreign_key "review_items_by_roles", "review_items"
  add_foreign_key "review_notes", "user_reviews"
  add_foreign_key "user_reviews", "review_items_by_roles"
  add_foreign_key "user_reviews", "users"
  add_foreign_key "users", "form_roles"
end
