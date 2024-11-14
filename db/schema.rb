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

ActiveRecord::Schema[7.1].define(version: 2024_11_14_231942) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "board_users", force: :cascade do |t|
    t.bigint "board_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.index ["board_id"], name: "index_board_users_on_board_id"
    t.index ["user_id", "board_id"], name: "index_board_users_on_user_id_and_board_id", unique: true
  end

  create_table "boards", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "share_token", null: false
    t.index ["deleted_at"], name: "index_boards_on_deleted_at", where: "(deleted_at IS NOT NULL)"
    t.index ["name"], name: "index_boards_on_name", unique: true
    t.index ["share_token"], name: "index_boards_on_share_token", unique: true
  end

  create_table "columns", force: :cascade do |t|
    t.bigint "board_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "column_order"
    t.index ["board_id", "name"], name: "index_columns_on_board_id_and_name", unique: true
  end

  create_table "timers", force: :cascade do |t|
    t.integer "duration", null: false
    t.bigint "board_id", null: false
    t.datetime "created_at", null: false
    t.index ["board_id"], name: "index_timers_on_board_id", unique: true
  end

  create_table "topics", force: :cascade do |t|
    t.bigint "column_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["column_id"], name: "index_topics_on_column_id"
    t.index ["user_id"], name: "index_topics_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "name", null: false
    t.string "image_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "guest", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "board_users", "boards"
  add_foreign_key "board_users", "users"
  add_foreign_key "columns", "boards"
  add_foreign_key "timers", "boards"
  add_foreign_key "topics", "columns"
  add_foreign_key "topics", "users"
end
