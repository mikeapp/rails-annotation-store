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

ActiveRecord::Schema.define(version: 20160904220726) do

  create_table "annotations", force: :cascade do |t|
    t.text     "data"
    t.text     "search_text"
    t.string   "motivation"
    t.string   "resource_id"
    t.boolean  "active"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "targets", force: :cascade do |t|
    t.string   "manifest"
    t.string   "canvas"
    t.text     "selector"
    t.string   "bbox"
    t.integer  "annotation_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["annotation_id"], name: "index_targets_on_annotation_id"
  end

end
