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

ActiveRecord::Schema.define(version: 2022_12_09_083145) do

  create_table "bills", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "cash_given"
    t.float "total_purchased_prize"
    t.float "total_tax_amount"
    t.float "total_bill_amount"
    t.float "rounded_bill_amount"
    t.float "balance_amount"
    t.index ["customer_id"], name: "index_bills_on_customer_id"
  end

  create_table "bills_customer_products", force: :cascade do |t|
    t.integer "bill_id", null: false
    t.integer "customer_product_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["bill_id"], name: "index_bills_customer_products_on_bill_id"
    t.index ["customer_product_id"], name: "index_bills_customer_products_on_customer_product_id"
  end

  create_table "customer_products", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "product_id", null: false
    t.integer "quantity"
    t.float "purchased_prize"
    t.float "tax_amount"
    t.float "total_prize"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id"], name: "index_customer_products_on_customer_id"
    t.index ["product_id"], name: "index_customer_products_on_product_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.float "unit_prize"
    t.float "tax_percentage"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "bills", "customers"
  add_foreign_key "bills_customer_products", "bills"
  add_foreign_key "bills_customer_products", "customer_products"
  add_foreign_key "customer_products", "customers"
  add_foreign_key "customer_products", "products"
end
