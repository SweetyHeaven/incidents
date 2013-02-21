# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130220143516) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "incidents", :force => true do |t|
    t.string   "info"
    t.integer  "incident_type",  :limit => 1
    t.integer  "score",                       :default => 5
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "creator_id"
    t.integer  "assigned_to_id"
  end

  create_table "incidents_tags", :id => false, :force => true do |t|
    t.integer "incident_id"
    t.integer "tag_id"
  end

  add_index "incidents_tags", ["incident_id", "tag_id"], :name => "index_incidents_tags_on_incident_id_and_tag_id"
  add_index "incidents_tags", ["tag_id", "incident_id"], :name => "index_incidents_tags_on_tag_id_and_incident_id"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",         :null => false
    t.string   "encrypted_password",     :default => "",         :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "score",                  :default => 0
    t.string   "role",                   :default => "Employee"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
