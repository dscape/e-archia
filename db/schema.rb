# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 5) do

  create_table "projects", :force => true do |t|
    t.integer  "user_id",                     :default => 1, :null => false
    t.string   "title",       :limit => 256,                 :null => false
    t.string   "subtitle",    :limit => 256
    t.string   "filepath"
    t.string   "filename"
    t.text     "contents",    :limit => 2048,                :null => false
    t.string   "authors",     :limit => 2048,                :null => false
    t.string   "supervisors", :limit => 2048,                :null => false
    t.string   "permalink",   :limit => 256,                 :null => false
    t.datetime "deadline"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["permalink"], :name => "index_projects_on_permalink"

  create_table "quotes", :force => true do |t|
    t.string   "quote",      :limit => 2048, :null => false
    t.string   "author",     :limit => 64,   :null => false
    t.string   "author_bio", :limit => 512,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rights", :force => true do |t|
    t.string   "name"
    t.string   "controller"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rights_roles", :id => false, :force => true do |t|
    t.integer  "right_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stories", :force => true do |t|
    t.string   "title",      :limit => 256,                 :null => false
    t.string   "contents",   :limit => 2048,                :null => false
    t.string   "permalink",  :limit => 256,                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",                    :default => 1, :null => false
  end

  add_index "stories", ["permalink"], :name => "index_stories_on_permalink"

  create_table "users", :force => true do |t|
    t.string   "username",      :limit => 64,                     :null => false
    t.string   "password_hash", :limit => 64,                     :null => false
    t.string   "password_salt", :limit => 8,                      :null => false
    t.string   "first_name",    :limit => 64,                     :null => false
    t.string   "last_name",     :limit => 64
    t.string   "email",         :limit => 128,                    :null => false
    t.string   "profile",       :limit => 2048
    t.string   "homepage",      :limit => 128
    t.string   "openid",        :limit => 128
    t.boolean  "enabled",                       :default => true, :null => false
    t.datetime "last_login_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["username"], :name => "index_users_on_username"

end
