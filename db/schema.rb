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

ActiveRecord::Schema.define(:version => 20080706143135) do

  create_table "comments", :force => true do |t|
    t.text     "comment"
    t.datetime "created_at",                                        :null => false
    t.integer  "commentable_id",   :limit => 11, :default => 0,     :null => false
    t.string   "commentable_type", :limit => 15, :default => "",    :null => false
    t.integer  "visitor_id",       :limit => 11, :default => 0,     :null => false
    t.boolean  "moderated",                      :default => false
  end

  add_index "comments", ["visitor_id"], :name => "fk_comments_visitor"

  create_table "current_stats", :force => true do |t|
    t.integer "region_id",  :limit => 11
    t.integer "name_id",    :limit => 11
    t.integer "year",       :limit => 11
    t.integer "count",      :limit => 11
    t.integer "rank",       :limit => 11
    t.integer "popularity", :limit => 1
  end

  add_index "current_stats", ["region_id", "year", "name_id"], :name => "index_current_stats_on_region_id_and_year_and_name_id", :unique => true
  add_index "current_stats", ["region_id"], :name => "region_id"
  add_index "current_stats", ["rank"], :name => "rank"
  add_index "current_stats", ["name_id"], :name => "index_current_stats_on_name_id"

  create_table "names", :force => true do |t|
    t.string  "name",                                                                         :null => false
    t.string  "gender"
    t.integer "rating_count", :limit => 11
    t.integer "rating_total", :limit => 10, :precision => 10, :scale => 0
    t.decimal "rating_avg",                 :precision => 10, :scale => 2
    t.boolean "is_popular",                                                :default => false
  end

  add_index "names", ["name", "gender"], :name => "index_names_on_name_and_gender", :unique => true
  add_index "names", ["gender"], :name => "gender"
  add_index "names", ["rating_avg"], :name => "rating_avg"
  add_index "names", ["is_popular"], :name => "index_names_on_is_popular"

  create_table "photos", :force => true do |t|
    t.integer  "parent_id",    :limit => 11
    t.integer  "name_id",      :limit => 11
    t.integer  "visitor_id",   :limit => 11
    t.string   "last_name"
    t.string   "location"
    t.date     "birthday"
    t.boolean  "moderated",                  :default => false
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size",         :limit => 11
    t.integer  "width",        :limit => 11
    t.integer  "height",       :limit => 11
    t.datetime "created_at"
  end

  create_table "ratings", :force => true do |t|
    t.integer "rater_id",   :limit => 11
    t.integer "rated_id",   :limit => 11
    t.string  "rated_type"
    t.integer "rating",     :limit => 10, :precision => 10, :scale => 0
  end

  add_index "ratings", ["rater_id"], :name => "index_ratings_on_rater_id"
  add_index "ratings", ["rated_type", "rated_id"], :name => "index_ratings_on_rated_type_and_rated_id"

  create_table "regions", :force => true do |t|
    t.string   "country",                                                                      :null => false
    t.string   "region",                                                                       :null => false
    t.string   "region_code",                                                                  :null => false
    t.decimal  "lat",                        :precision => 10, :scale => 6,                    :null => false
    t.decimal  "lng",                        :precision => 10, :scale => 6,                    :null => false
    t.string   "stats_name",                                                                   :null => false
    t.string   "stats_desc"
    t.string   "stats_url"
    t.integer  "current_year", :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country_code"
    t.boolean  "is_country",                                                :default => false
    t.boolean  "has_icon",                                                  :default => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stats", :force => true do |t|
    t.integer "region_id", :limit => 11
    t.integer "name_id",   :limit => 11
    t.integer "year",      :limit => 11
    t.integer "count",     :limit => 11
  end

  add_index "stats", ["region_id", "year", "name_id"], :name => "index_stats_on_region_id_and_year_and_name_id", :unique => true
  add_index "stats", ["name_id"], :name => "name_idx"

  create_table "visitors", :force => true do |t|
    t.string   "ip_addr"
    t.datetime "created_at"
    t.string   "name"
  end

end
