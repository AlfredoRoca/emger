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

ActiveRecord::Schema.define(version: 20141025085018) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: true do |t|
    t.string   "name"
    t.string   "activity"
    t.string   "phone1"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "companies", ["name"], name: "index_companies_on_name", using: :btree

  create_table "emergencies", force: true do |t|
    t.datetime "date"
    t.string   "status"
    t.boolean  "simulacrum"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", force: true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "lastname"
  end

  add_index "people", ["email"], name: "index_people_on_email", using: :btree

  create_table "places", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "coord_x"
    t.string   "coord_y"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "places", ["name"], name: "index_places_on_name", using: :btree

  create_table "scenarios", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scenarios", ["name"], name: "index_scenarios_on_name", using: :btree

end
