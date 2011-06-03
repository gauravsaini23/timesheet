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

ActiveRecord::Schema.define(:version => 20100913082815) do

  create_table "employee_projects", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "project_id"
    t.string   "employee_name"
    t.string   "project_name"
    t.time     "allocated_at"
    t.time     "deallocated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "date_of_joining"
    t.datetime "date_of_leaving"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "deactivated_at"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timesheets", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "project_id"
    t.string   "employee_name"
    t.string   "project_name"
    t.string   "description"
    t.time     "duration"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "hashed_password"
    t.string   "salt"
    t.boolean  "is_admin"
    t.boolean  "is_active",             :default => false
    t.integer  "employee_id"
    t.string   "forgot_password_hash"
    t.string   "confirm_creation_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
