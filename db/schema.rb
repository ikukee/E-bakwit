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

ActiveRecord::Schema[7.0].define(version: 2023_08_27_033647) do
  create_table "assigned_yearly_esses", force: :cascade do |t|
    t.integer "ess_id"
    t.integer "evac_profile_id"
    t.integer "quantity"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "assigned_yearly_vols", force: :cascade do |t|
    t.integer "volunteer_id"
    t.integer "evac_profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "camp_managers", force: :cascade do |t|
    t.string "fname"
    t.string "lname"
    t.string "cnum"
    t.string "address"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "evac_centers", force: :cascade do |t|
    t.string "name"
    t.boolean "isInside"
    t.string "barangay"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "evac_esses", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "evac_facilities", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "evac_yearly_profiles", force: :cascade do |t|
    t.integer "evac_id"
    t.integer "manager_id"
    t.date "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "fname"
    t.string "lname"
    t.string "password_digest"
    t.string "email"
    t.string "cnum"
    t.string "user_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
