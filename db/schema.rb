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

ActiveRecord::Schema[7.1].define(version: 2024_07_01_185537) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_requests", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "endpoint"
    t.string "remote_ip"
    t.string "status"
    t.json "payload"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_api_requests_on_user_id"
  end

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.bigint "country_id", null: false
    t.text "description"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_brands_on_country_id"
    t.index ["name", "country_id"], name: "index_brands_on_name_and_country_id", unique: true
  end

  create_table "cards", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "user_id", null: false
    t.string "activation_number", null: false
    t.string "pin"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_cards_on_product_id"
    t.index ["user_id"], name: "index_cards_on_user_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_countries_on_code", unique: true
    t.index ["name"], name: "index_countries_on_name", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.decimal "price"
    t.string "status"
    t.bigint "brand_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_products_on_brand_id"
    t.index ["name", "brand_id"], name: "index_products_on_name_and_brand_id", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "product_id", null: false
    t.integer "transaction_type"
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_transactions_on_product_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.string "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role"], name: "index_user_roles_on_role", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "authentication_token"
    t.bigint "user_role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["user_role_id"], name: "index_users_on_user_role_id"
  end

  create_table "users_products", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_users_products_on_product_id"
    t.index ["user_id", "product_id"], name: "index_users_products_on_user_id_and_product_id", unique: true
    t.index ["user_id"], name: "index_users_products_on_user_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "api_requests", "users"
  add_foreign_key "brands", "countries"
  add_foreign_key "cards", "products"
  add_foreign_key "cards", "users"
  add_foreign_key "products", "brands"
  add_foreign_key "transactions", "products"
  add_foreign_key "transactions", "users"
  add_foreign_key "users", "user_roles"
  add_foreign_key "users_products", "products"
  add_foreign_key "users_products", "users"
end
