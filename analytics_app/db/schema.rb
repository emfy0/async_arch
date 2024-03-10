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

ActiveRecord::Schema[7.1].define(version: 2024_03_10_182005) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "billing_cycles", force: :cascade do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean "active", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_billing_cycles_on_active", where: "active"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "transaction_id", null: false
    t.bigint "billing_cycle_id", null: false
    t.decimal "amount", default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["billing_cycle_id"], name: "index_payments_on_billing_cycle_id"
    t.index ["transaction_id"], name: "index_payments_on_transaction_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.uuid "public_id", null: false
    t.decimal "reward", null: false
    t.decimal "penalty", null: false
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jira_id"
    t.index ["public_id"], name: "index_tasks_on_public_id", unique: true
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "task_id"
    t.bigint "billing_cycle_id", null: false
    t.string "kind", null: false
    t.decimal "debit", default: "0.0", null: false
    t.decimal "credit", default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["billing_cycle_id"], name: "index_transactions_on_billing_cycle_id"
    t.index ["task_id"], name: "index_transactions_on_task_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "role", null: false
    t.decimal "balance", default: "0.0", null: false
    t.uuid "public_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["public_id"], name: "index_users_on_public_id", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "payments", "billing_cycles"
  add_foreign_key "payments", "transactions"
  add_foreign_key "payments", "users"
  add_foreign_key "tasks", "users"
  add_foreign_key "transactions", "billing_cycles"
  add_foreign_key "transactions", "tasks"
  add_foreign_key "transactions", "users"
end
