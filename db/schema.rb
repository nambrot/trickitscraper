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

ActiveRecord::Schema.define(version: 20140326221032) do

  create_table "forum_threads", force: true do |t|
    t.integer  "last_page_scraped"
    t.string   "link"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "to_scrape",                 default: false
    t.boolean  "to_page_track",             default: false
    t.text     "page_counts",               default: "--- []\n"
    t.date     "marked_as_fast_growing_at"
  end

  create_table "links", force: true do |t|
    t.string   "name"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.integer  "uid"
    t.text     "body"
    t.string   "username"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "forum_thread_id"
  end

  add_index "posts", ["uid"], name: "index_posts_on_uid", unique: true

  create_table "rails_admin_histories", force: true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      limit: 2
    t.integer  "year",       limit: 5
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], name: "index_rails_admin_histories"

end
