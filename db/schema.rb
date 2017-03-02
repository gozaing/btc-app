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

ActiveRecord::Schema.define(version: 20170302135728) do

  create_table "Tickers", force: :cascade do |t|
    t.integer  "tick_id"
    t.string   "best_bid"
    t.string   "best_ask"
    t.string   "best_bid_size"
    t.string   "best_ask_size"
    t.string   "total_bid_depth"
    t.string   "total_ask_depth"
    t.string   "ltp"
    t.string   "volume"
    t.string   "volume_by_product"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "children", force: :cascade do |t|
    t.string   "parent_order_id"
    t.string   "child_order_id"
    t.string   "child_order_type"
    t.string   "side"
    t.decimal  "price"
    t.decimal  "average_price"
    t.decimal  "size"
    t.string   "child_order_state"
    t.datetime "child_order_date"
    t.string   "child_order_acceptance_id"
    t.decimal  "executed_size"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "differences", force: :cascade do |t|
    t.integer  "diff_id"
    t.decimal  "ltp"
    t.decimal  "diff"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parents", force: :cascade do |t|
    t.string   "parent_order_id"
    t.string   "parent_order_acceptance_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "status"
  end

  create_table "results", force: :cascade do |t|
    t.string   "parent_order_id"
    t.string   "buy_child_order_id"
    t.decimal  "buy_price"
    t.string   "sell_child_order_id"
    t.decimal  "sel_price"
    t.decimal  "diff"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

end
