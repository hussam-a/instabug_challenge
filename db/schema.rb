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

ActiveRecord::Schema.define(version: 2019_11_29_002941) do

  create_table "apps", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "token"
    t.integer "chats_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_apps_on_token"
  end

  create_table "chats", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "chat_number"
    t.bigint "app_id"
    t.integer "messages_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_id"], name: "fk_rails_de65013ee8"
    t.index ["chat_number"], name: "index_chats_on_chat_number"
  end

  create_table "messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "chat_id"
    t.integer "message_number"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "fk_rails_0f670de7ba"
    t.index ["message_number"], name: "index_messages_on_message_number"
  end

  add_foreign_key "chats", "apps", on_delete: :cascade
  add_foreign_key "messages", "chats", on_delete: :cascade
  create_trigger("chats_after_insert_row_tr", :generated => true, :compatibility => 1).
      on("chats").
      after(:insert) do
    "UPDATE apps SET chats_count = chats_count + 1 WHERE apps.id = NEW.app_id;"
  end

  create_trigger("messages_after_insert_row_tr", :generated => true, :compatibility => 1).
      on("messages").
      after(:insert) do
    "UPDATE chats SET messages_count = messages_count + 1 WHERE chats.id = NEW.chat_id;"
  end

  create_trigger("chats_after_delete_row_tr", :generated => true, :compatibility => 1).
      on("chats").
      after(:delete) do
    "UPDATE apps SET chats_count = chats_count - 1 WHERE apps.id = OLD.app_id;"
  end

  create_trigger("messages_after_delete_row_tr", :generated => true, :compatibility => 1).
      on("messages").
      after(:delete) do
    "UPDATE chats SET messages_count = messages_count - 1 WHERE chats.id = OLD.chat_id;"
  end

end
