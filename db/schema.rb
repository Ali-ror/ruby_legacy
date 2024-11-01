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

ActiveRecord::Schema.define(:version => 20140105194800) do

  create_table "addresses", :force => true do |t|
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.integer  "model_id"
    t.string   "model_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "addresses", ["model_id", "model_type"], :name => "index_addresses_on_model_id_and_model_type"

  create_table "affiliates", :force => true do |t|
    t.string   "name"
    t.string   "logo"
    t.integer  "position"
    t.integer  "territory_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link"
  end

  create_table "banners", :force => true do |t|
    t.integer  "territory_id"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link"
    t.string   "size"
    t.string   "banner"
    t.integer  "location_mask"
  end

  create_table "business_listing_categories", :force => true do |t|
    t.integer "category_id"
    t.integer "business_listing_id"
  end

  add_index "business_listing_categories", ["category_id", "business_listing_id"], :name => "bl_cats_index"

  create_table "business_listings", :force => true do |t|
    t.string   "name"
    t.date     "expires"
    t.string   "state"
    t.boolean  "featured"
    t.date     "featured_date"
    t.string   "operating_hours"
    t.string   "phone"
    t.string   "fax"
    t.string   "skype"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "territory_id"
    t.string   "package_type"
    t.string   "short_description"
    t.text     "long_description"
    t.boolean  "hide_address"
    t.boolean  "hide_map"
    t.string   "email"
    t.integer  "user_id"
    t.integer  "visits"
    t.string   "logo"
    t.string   "background_image"
    t.string   "business_tier"
    t.boolean  "reward_reseller"
    t.boolean  "published"
    t.string   "owner_photo"
    t.string   "owner_name"
    t.text     "owner_bio"
    t.text     "mobile_friendly_description"
    t.boolean  "featured_mobile"
    t.date     "featured_mobile_date"
    t.boolean  "featured_owner"
    t.date     "featured_owner_date"
    t.string   "mobile_logo"
    t.boolean  "show_default_banners_only"
  end

  add_index "business_listings", ["territory_id", "state", "expires"], :name => "index_business_listings_on_territory_id_and_state_and_expires"

  create_table "categories", :force => true do |t|
    t.string  "name"
    t.integer "parent_id"
    t.integer "lft"
    t.integer "rgt"
    t.integer "territory_id"
    t.string  "path_name_cache"
  end

  add_index "categories", ["territory_id", "name"], :name => "index_categories_on_territory_id_and_name"

  create_table "cities", :force => true do |t|
    t.string   "city"
    t.string   "state"
    t.integer  "territory_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug"
  end

  create_table "comments", :force => true do |t|
    t.text     "comment"
    t.string   "state"
    t.integer  "rating"
    t.integer  "business_listing_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupons", :force => true do |t|
    t.date     "expiration_date"
    t.string   "description"
    t.string   "title"
    t.boolean  "featured"
    t.integer  "position"
    t.string   "coupon_image"
    t.integer  "business_listing_id"
    t.string   "restrictions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active_in_mobile_apps", :default => true
  end

  create_table "daily_deals", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "restrictions"
    t.date     "expiration_date"
    t.string   "deal_image"
    t.integer  "business_listing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "deal_date"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "when"
    t.string   "url"
    t.string   "public_email"
    t.string   "private_email"
    t.string   "state"
    t.integer  "user_id"
    t.integer  "territory_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "duration"
  end

  create_table "file_models", :force => true do |t|
    t.string   "title"
    t.integer  "business_listing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_attachment"
  end

  create_table "headers", :force => true do |t|
    t.integer  "territory_id"
    t.string   "credit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "header"
    t.string   "link"
  end

  create_table "hidden_categories", :force => true do |t|
    t.integer  "territory_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "legacy_coupons", :force => true do |t|
    t.string  "legacy_coupon"
    t.integer "business_listing_id"
  end

  create_table "link_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", :force => true do |t|
    t.string   "url"
    t.integer  "link_type_id"
    t.integer  "model_id"
    t.string   "model_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pictures", :force => true do |t|
    t.string   "caption"
    t.integer  "business_listing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture"
    t.string   "state"
  end

  create_table "rewards", :force => true do |t|
    t.string   "description"
    t.date     "expiration_date"
    t.boolean  "never_expires"
    t.integer  "business_listing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "sub_pages", :force => true do |t|
    t.integer  "territory_id"
    t.string   "page_title"
    t.string   "meta_content_description"
    t.string   "meta_tags"
    t.text     "body_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "territories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "tracking_code"
    t.string   "cached_slug"
    t.string   "featured_link"
    t.string   "page_title"
    t.string   "meta_description"
    t.string   "meta_tags"
    t.boolean  "hide_events_calendar"
    t.boolean  "rewards_enabled"
    t.boolean  "deal_of_the_day_enabled"
    t.string   "brand_name"
    t.string   "brand_default_logo"
    t.string   "territory_type"
  end

  create_table "territory_texts", :force => true do |t|
    t.integer  "territory_id"
    t.string   "contents_type", :limit => 50
    t.text     "contents",      :limit => 2147483647
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_coupons", :force => true do |t|
    t.integer "user_id"
    t.integer "coupon_id"
  end

  create_table "user_daily_deals", :force => true do |t|
    t.integer "user_id"
    t.integer "daily_deal_id"
  end

  create_table "user_territories", :force => true do |t|
    t.integer  "user_id"
    t.integer  "territory_id"
    t.boolean  "local_admin"
    t.boolean  "subscribe_email_list"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "subscribe_daily_deal_email"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",    :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",    :null => false
    t.string   "password_salt",                       :default => "",    :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "fax"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login"
    t.boolean  "global_admin",                        :default => false
    t.boolean  "opt_in_newsletter",                   :default => false
    t.string   "authentication_token"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
