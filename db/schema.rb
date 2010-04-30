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

ActiveRecord::Schema.define(:version => 20100430153416) do

  create_table "campus", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "energy_readings", :force => true do |t|
    t.float   "frequency"
    t.float   "voltage"
    t.float   "voltage_a"
    t.float   "voltage_b"
    t.float   "current"
    t.float   "current_a"
    t.float   "current_b"
    t.float   "power"
    t.float   "power_a"
    t.float   "power_b"
    t.float   "energy"
    t.float   "energy_a"
    t.float   "energy_b"
    t.integer "reading_id"
    t.integer "source_id"
  end

  create_table "readings", :force => true do |t|
    t.datetime "created_at"
  end

  create_table "source_types", :force => true do |t|
    t.string   "name",       :null => false
    t.boolean  "production"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sources", :force => true do |t|
    t.string   "name",           :null => false
    t.integer  "campus_id"
    t.integer  "source_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "weather_readings", :force => true do |t|
    t.float   "temperature"
    t.float   "irradiance"
    t.float   "wind_speed"
    t.float   "wind_direction"
    t.integer "reading_id"
  end

end
