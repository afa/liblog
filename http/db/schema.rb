# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090620052846) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "text"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blog_comments", :force => true do |t|
    t.string   "title"
    t.text     "text"
    t.integer  "blog_post_id"
    t.integer  "blog_comment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blog_posts", :force => true do |t|
    t.string   "title"
    t.text     "text"
    t.integer  "identity_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "file_storeds", :force => true do |t|
    t.string   "location"
    t.string   "uri"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "identities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "imported_entries", :force => true do |t|
    t.string   "source_server"
    t.datetime "source_created_at"
    t.string   "source_url",        :null => false
    t.integer  "blog_post_id",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "privilege_maps", :force => true do |t|
    t.integer "privilege_id"
    t.integer "role_id"
  end

  create_table "privileges", :force => true do |t|
    t.string "name"
    t.string "title"
  end

  create_table "role_maps", :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"
  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"

  create_table "site_configs", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "some_things", :force => true do |t|
    t.string   "base_path",  :null => false
    t.string   "name",       :null => false
    t.integer  "dir_count",  :null => false
    t.string   "base_url",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "things", :force => true do |t|
    t.string   "name",           :null => false
    t.string   "title"
    t.integer  "some_things_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "to_dos", :force => true do |t|
    t.text     "text"
    t.date     "to_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "done"
    t.integer  "parent_id"
    t.integer  "prio_level"
    t.integer  "priority"
    t.integer  "project_id"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.integer  "identity_id"
    t.string   "password"
    t.boolean  "can_admin"
    t.boolean  "can_post"
    t.boolean  "can_login"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
