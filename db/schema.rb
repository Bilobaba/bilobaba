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

ActiveRecord::Schema.define(version: 20171211112740) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attend_events", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_attend_events_on_event_id"
    t.index ["member_id"], name: "index_attend_events_on_member_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.bigint "event_id"
    t.bigint "autor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["autor_id"], name: "index_comments_on_autor_id"
    t.index ["event_id"], name: "index_comments_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.datetime "begin"
    t.datetime "end"
    t.integer "price_min"
    t.integer "price_max"
    t.integer "members_max"
    t.string "adress"
    t.string "town"
    t.string "zip"
    t.float "lat"
    t.float "lng"
    t.bigint "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.json "photos"
    t.string "photo1"
    t.string "photo2"
    t.string "photo3"
    t.string "photo4"
    t.string "photo5"
    t.index ["member_id"], name: "index_events_on_member_id"
  end

  create_table "events_smihug", id: :serial, force: :cascade do |t|
    t.string "titre"
    t.text "description"
    t.integer "prix"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "debut"
    t.datetime "fin"
    t.string "lieu"
    t.string "adresse"
    t.string "cp"
    t.string "ville"
    t.string "pays"
    t.string "reduit"
    t.string "contact"
    t.string "transport"
    t.integer "user_id"
    t.text "search_text"
    t.string "site"
    t.string "complement"
    t.index ["user_id"], name: "index_events_smihug_on_user_id"
  end

  create_table "follow_events", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_follow_events_on_event_id"
    t.index ["member_id"], name: "index_follow_events_on_member_id"
  end

  create_table "follows", force: :cascade do |t|
    t.bigint "follower_id"
    t.bigint "followee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followee_id"], name: "index_follows_on_followee_id"
    t.index ["follower_id"], name: "index_follows_on_follower_id"
  end

  create_table "like_events", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_like_events_on_event_id"
    t.index ["member_id"], name: "index_like_events_on_member_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "pseudo"
    t.string "first_name"
    t.string "name"
    t.string "bio"
    t.datetime "birth_date"
    t.string "adress"
    t.string "zip"
    t.string "town"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar"
    t.index ["confirmation_token"], name: "index_members_on_confirmation_token", unique: true
    t.index ["email"], name: "index_members_on_email", unique: true
    t.index ["pseudo"], name: "index_members_on_pseudo", unique: true
    t.index ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true
  end

  create_table "members_roles", id: false, force: :cascade do |t|
    t.bigint "member_id"
    t.bigint "role_id"
    t.index ["member_id", "role_id"], name: "index_members_roles_on_member_id_and_role_id"
    t.index ["member_id"], name: "index_members_roles_on_member_id"
    t.index ["role_id"], name: "index_members_roles_on_role_id"
  end

  create_table "profils_smihug", id: :serial, force: :cascade do |t|
    t.string "nom"
    t.string "prenom"
    t.string "pseudo"
    t.text "detail"
    t.string "site"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "activite"
    t.text "search_text"
    t.boolean "pro"
    t.index ["user_id"], name: "index_profils_smihug_on_user_id"
  end

  create_table "recommend_events", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_recommend_events_on_event_id"
    t.index ["member_id"], name: "index_recommend_events_on_member_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "users_smihug", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_smihug_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_smihug_on_reset_password_token", unique: true
  end

  add_foreign_key "attend_events", "events"
  add_foreign_key "attend_events", "members"
  add_foreign_key "comments", "events"
  add_foreign_key "comments", "members", column: "autor_id"
  add_foreign_key "events", "members"
  add_foreign_key "events_smihug", "users_smihug", column: "user_id"
  add_foreign_key "follow_events", "events"
  add_foreign_key "follow_events", "members"
  add_foreign_key "like_events", "events"
  add_foreign_key "like_events", "members"
  add_foreign_key "profils_smihug", "users_smihug", column: "user_id"
  add_foreign_key "recommend_events", "events"
  add_foreign_key "recommend_events", "members"
end
