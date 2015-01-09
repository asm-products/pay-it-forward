# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150109011146) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "charities", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "url"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "pledges", force: :cascade do |t|
    t.integer  "referrer_id"
    t.integer  "user_id"
    t.integer  "action"
    t.datetime "expiration"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "tip_percentage"
    t.integer  "amount"
    t.string   "stripe_authorization_charge_id"
    t.integer  "charity_id"
    t.string   "stripe_charge_id"
    t.integer  "state"
  end

  add_index "pledges", ["charity_id"], name: "index_pledges_on_charity_id", using: :btree
  add_index "pledges", ["referrer_id"], name: "index_pledges_on_referrer_id", using: :btree
  add_index "pledges", ["user_id"], name: "index_pledges_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",              null: false
    t.string   "crypted_password",   null: false
    t.string   "salt",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "stripe_customer_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
