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

ActiveRecord::Schema[7.0].define(version: 2023_09_18_072156) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

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

  create_table "disasters", force: :cascade do |t|
    t.string "name"
    t.string "disaster_type"
    t.date "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "evac_centers", force: :cascade do |t|
    t.string "name"
    t.boolean "isInside"
    t.string "barangay"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "capacity"
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

  create_table "evacuation_essentials", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "ess_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "families", force: :cascade do |t|
    t.string "name"
    t.integer "houseNum"
    t.integer "streetNum"
    t.string "barangay"
    t.boolean "is_4ps"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "zone"
    t.string "streetName"
    t.boolean "is_evacuated"
  end

  create_table "family_members", force: :cascade do |t|
    t.integer "family_id"
    t.string "fname"
    t.string "lname"
    t.integer "age"
    t.boolean "is_pregnant"
    t.boolean "is_parent"
    t.boolean "is_pwd"
    t.boolean "is_breastfeeding"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sex"
  end

  create_table "relief_goods", force: :cascade do |t|
    t.string "name"
    t.boolean "is_food"
    t.string "unit"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "requests", force: :cascade do |t|
    t.string "fname"
    t.string "lname"
    t.date "bdate"
    t.string "email"
    t.string "address"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cnum"
    t.date "request_date"
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
    t.date "bdate"
    t.string "address"
    t.string "status"
    t.boolean "assigned"
    t.string "full_name"
    t.integer "currently_assigned"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
