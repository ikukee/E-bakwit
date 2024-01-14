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

ActiveRecord::Schema[7.0].define(version: 2023_12_20_075928) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.text "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.text "key", null: false
    t.text "filename", null: false
    t.text "content_type"
    t.text "metadata"
    t.text "service_name", null: false
    t.bigint "byte_size", null: false
    t.text "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.text "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "assigned_yearly_esses", force: :cascade do |t|
    t.integer "ess_id"
    t.integer "evac_profile_id"
    t.integer "quantity"
    t.text "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "assigned_yearly_vols", force: :cascade do |t|
    t.integer "volunteer_id"
    t.integer "evac_profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "disasters", force: :cascade do |t|
    t.text "name"
    t.text "disaster_type"
    t.text "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date_of_occurence"
  end

  create_table "dispatched_rgs", force: :cascade do |t|
    t.integer "request_id"
    t.integer "rg_id"
    t.integer "quantity"
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "evac_centers", force: :cascade do |t|
    t.text "name"
    t.boolean "isInside"
    t.text "barangay"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "capacity"
    t.text "status"
  end

  create_table "evac_members", force: :cascade do |t|
    t.integer "evacuee_id"
    t.integer "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "status"
  end

  create_table "evac_yearly_profiles", force: :cascade do |t|
    t.integer "evac_id"
    t.integer "manager_id"
    t.text "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "evacuation_essentials", force: :cascade do |t|
    t.text "name"
    t.text "description"
    t.text "ess_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "evacuees", force: :cascade do |t|
    t.integer "disaster_id"
    t.integer "family_id"
    t.datetime "date_in"
    t.datetime "date_out"
    t.integer "evac_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "family_name"
    t.text "relief_good_status"
  end

  create_table "families", force: :cascade do |t|
    t.text "name"
    t.integer "houseNum"
    t.integer "streetNum"
    t.text "barangay"
    t.boolean "is_4ps"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "zone"
    t.text "streetName"
    t.boolean "is_evacuated"
  end

  create_table "family_members", force: :cascade do |t|
    t.integer "family_id"
    t.text "fname"
    t.text "lname"
    t.integer "age"
    t.boolean "is_pregnant"
    t.boolean "is_parent"
    t.boolean "is_pwd"
    t.boolean "is_breastfeeding"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "sex"
    t.integer "evacuee_id"
    t.text "full_name"
  end

  create_table "gen_rg_allocs", force: :cascade do |t|
    t.integer "rg_id"
    t.integer "disaster_id"
    t.integer "evac_id"
    t.float "quantity"
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "price"
  end

  create_table "password_sessions", force: :cascade do |t|
    t.integer "user_id"
    t.date "expiration_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "exp_date"
  end

  create_table "relief_good_to_evacuees", force: :cascade do |t|
    t.integer "evacuee_id"
    t.integer "criterium_id"
    t.integer "gen_id"
    t.float "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "batch"
  end

  create_table "relief_goods", force: :cascade do |t|
    t.text "name"
    t.text "unit"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_food"
    t.text "eligibility"
    t.text "category"
  end

  create_table "relief_requests", force: :cascade do |t|
    t.integer "volunteer_id"
    t.integer "evac_id"
    t.integer "disaster_id"
    t.text "status"
    t.text "message"
    t.date "date_of_request"
    t.date "date_of_dispatch"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "requests", force: :cascade do |t|
    t.text "fname"
    t.text "lname"
    t.date "bdate"
    t.text "email"
    t.text "address"
    t.text "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "cnum"
    t.date "request_date"
    t.text "user_type"
  end

  create_table "rg_criteria", force: :cascade do |t|
    t.integer "gen_rg_alloc_id"
    t.integer "criteria"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.text "fname"
    t.text "lname"
    t.text "password_digest"
    t.text "email"
    t.text "cnum"
    t.text "user_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "bdate"
    t.text "address"
    t.text "status"
    t.boolean "assigned"
    t.text "full_name"
    t.integer "currently_assigned"
  end

  create_table "years", force: :cascade do |t|
    t.text "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
