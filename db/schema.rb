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

ActiveRecord::Schema.define(version: 2020_11_29_053026) do

  create_table "accounts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "uuid", limit: 36, null: false
    t.string "name", null: false
    t.string "full_domain", null: false
    t.string "time_zone", limit: 100
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["full_domain"], name: "index_accounts_on_full_domain", unique: true
    t.index ["uuid"], name: "index_accounts_on_uuid", unique: true
  end

  create_table "activities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "user_id", null: false
    t.string "description", null: false
    t.integer "notable_id", null: false
    t.string "notable_type", null: false
    t.text "activity_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "created_at"], name: "index_activities_on_account_id_and_created_at", unique: true
  end

  create_table "domain_mappings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "domain", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain"], name: "index_domain_mappings_on_domain", unique: true
  end

  create_table "email_notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.boolean "admin_notification", default: true
    t.boolean "user_notification", default: true
    t.integer "notification_type", default: 0, null: false
    t.text "content"
    t.integer "version", default: 1, null: false
    t.text "options"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "notification_type"], name: "index_email_notifications_on_account_id_and_notification_type", unique: true
  end

  create_table "environment_configs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "environment_id", null: false
    t.bigint "feature_flag_id", null: false
    t.json "config"
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "environment_id", "feature_flag_id"], name: "unique_config", unique: true
  end

  create_table "environments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "project_id", null: false
    t.string "name", null: false
    t.string "description"
    t.string "client_id", null: false
    t.string "api_key", null: false
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "project_id", "name"], name: "index_environments_on_account_id_and_project_id_and_name", unique: true
    t.index ["api_key"], name: "index_environments_on_api_key", unique: true
  end

  create_table "feature_flags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "project_id", null: false
    t.string "name", null: false
    t.string "key", null: false
    t.string "description"
    t.boolean "deleted", default: false
    t.text "variations"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "name"], name: "index_feature_flags_on_account_id_and_name", unique: true
  end

  create_table "projects", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "name", null: false
    t.string "uuid", null: false
    t.string "description"
    t.text "config"
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "name"], name: "index_projects_on_account_id_and_name", unique: true
    t.index ["account_id", "uuid"], name: "index_projects_on_account_id_and_uuid", unique: true
    t.index ["uuid"], name: "index_projects_on_uuid", unique: true
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "first_name", null: false
    t.string "middle_name"
    t.string "last_name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email", "account_id"], name: "index_users_on_email_and_account_id", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
