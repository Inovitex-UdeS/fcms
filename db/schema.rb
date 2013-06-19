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

ActiveRecord::Schema.define(:version => 20130619022853) do

  create_table "agegroups", :force => true do |t|
    t.integer  "edition_id",                  :null => false
    t.integer  "category_id",                 :null => false
    t.date     "min"
    t.date     "max"
    t.string   "description",  :limit => 128
    t.integer  "fee"
    t.integer  "max_duration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "agegroups", ["category_id"], :name => "category_id_fk"
  add_index "agegroups", ["edition_id"], :name => "edition_id_fk"
  add_index "agegroups", ["id"], :name => "agegroups_pk", :unique => true

  create_table "categories", :force => true do |t|
    t.string   "name",        :limit => 256, :null => false
    t.integer  "nb_perf_min",                :null => false
    t.integer  "nb_perf_max"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["id"], :name => "categories_pk", :unique => true
  add_index "categories", ["name"], :name => "ak_name_categori", :unique => true

  create_table "cities", :force => true do |t|
    t.string   "name",       :limit => 64, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cities", ["id"], :name => "cities_pk", :unique => true
  add_index "cities", ["name"], :name => "ak_name_cities", :unique => true

  create_table "composers", :force => true do |t|
    t.string   "name",       :limit => 256, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "composers", ["id"], :name => "composers_pk", :unique => true
  add_index "composers", ["name"], :name => "ak_name_composer", :unique => true

  create_table "configs", :id => false, :force => true do |t|
    t.string "key",   :limit => 64,   :null => false
    t.string "value", :limit => 1024
  end

  add_index "configs", ["key"], :name => "configs_pk", :unique => true

  create_table "contactinfos", :force => true do |t|
    t.integer  "city_id",                    :null => false
    t.string   "telephone",   :limit => 16
    t.string   "address",     :limit => 256
    t.string   "address2",    :limit => 256
    t.string   "postal_code", :limit => 6
    t.string   "province",    :limit => 256
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contactinfos", ["city_id"], :name => "city_id_fk"
  add_index "contactinfos", ["id"], :name => "contactinfos_pk", :unique => true

  create_table "contests", :force => true do |t|
  end

  add_index "contests", ["id"], :name => "contests_pk", :unique => true

  create_table "editions", :force => true do |t|
    t.integer  "year",       :null => false
    t.date     "limit_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.date     "end_date"
  end

  add_index "editions", ["id"], :name => "editions_pk", :unique => true
  add_index "editions", ["year"], :name => "ak_year_editions", :unique => true

  create_table "evaluations", :id => false, :force => true do |t|
    t.integer "id", :null => false
  end

  add_index "evaluations", ["id"], :name => "evaluations_pk", :unique => true

  create_table "instruments", :force => true do |t|
    t.string   "name",       :limit => 64, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "instruments", ["id"], :name => "instruments_pk", :unique => true
  add_index "instruments", ["name"], :name => "ak_name_instrume", :unique => true

  create_table "payments", :force => true do |t|
    t.integer  "user_id",                                                        :null => false
    t.integer  "registration_id",                                                :null => false
    t.string   "mode",            :limit => 64
    t.integer  "no_chq"
    t.string   "name_chq",        :limit => 1024
    t.date     "date_chq"
    t.date     "depot_date"
    t.string   "invoice",         :limit => 64
    t.decimal  "cash",                            :precision => 19, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payments", ["id"], :name => "payments_pk", :unique => true
  add_index "payments", ["registration_id"], :name => "registration_id_fk2"
  add_index "payments", ["user_id"], :name => "user_id_fk"

  create_table "performances", :force => true do |t|
    t.integer  "piece_id",        :null => false
    t.integer  "registration_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "performances", ["id"], :name => "performances_pk", :unique => true
  add_index "performances", ["piece_id"], :name => "piece_id_fk"
  add_index "performances", ["registration_id"], :name => "registration_id_fk"

  create_table "pieces", :force => true do |t|
    t.integer  "composer_id",                :null => false
    t.string   "title",       :limit => 256, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pieces", ["composer_id"], :name => "composer_id_fk"
  add_index "pieces", ["id"], :name => "pieces_pk", :unique => true
  add_index "pieces", ["title"], :name => "ak_title_pieces", :unique => true

  create_table "registrations", :force => true do |t|
    t.integer  "user_owner_id",   :null => false
    t.integer  "school_id"
    t.integer  "registration_id"
    t.integer  "user_teacher_id", :null => false
    t.integer  "edition_id",      :null => false
    t.integer  "category_id",     :null => false
    t.integer  "duration",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "registrations", ["category_id"], :name => "category_id_fk2"
  add_index "registrations", ["edition_id"], :name => "edition_id_fk2"
  add_index "registrations", ["id"], :name => "registrations_pk", :unique => true
  add_index "registrations", ["registration_id"], :name => "registration_id_fk3"
  add_index "registrations", ["school_id"], :name => "school_id_fk"
  add_index "registrations", ["user_owner_id"], :name => "user_owner_id_fk"
  add_index "registrations", ["user_teacher_id"], :name => "user_teacher_id_fk"

  create_table "registrations_users", :id => false, :force => true do |t|
    t.integer  "instrument_id",   :null => false
    t.integer  "registration_id", :null => false
    t.integer  "user_id",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "registrations_users", ["instrument_id", "registration_id", "user_id"], :name => "registrations_users_pk", :unique => true
  add_index "registrations_users", ["instrument_id"], :name => "instrument_id_fk"
  add_index "registrations_users", ["registration_id"], :name => "registration_id_fk4"
  add_index "registrations_users", ["user_id"], :name => "user_id_fk3"

  create_table "roles", :force => true do |t|
    t.string   "name",       :limit => 256, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["id"], :name => "roles_pk", :unique => true
  add_index "roles", ["name"], :name => "ak_name_roles", :unique => true

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "role_id",    :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles_users", ["role_id", "user_id"], :name => "roles_users_pk", :unique => true
  add_index "roles_users", ["role_id"], :name => "role_id_fk"
  add_index "roles_users", ["user_id"], :name => "user_id_fk2"

  create_table "rooms", :force => true do |t|
    t.integer  "capacity"
    t.string   "name"
    t.string   "location",    :limit => 1024
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rooms", ["id"], :name => "rooms_pk", :unique => true

  create_table "schoolboards", :force => true do |t|
    t.string   "name",       :limit => 128, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schoolboards", ["id"], :name => "schoolboards_pk", :unique => true
  add_index "schoolboards", ["name"], :name => "ak_name_schoolbo", :unique => true

  create_table "schools", :force => true do |t|
    t.integer  "contactinfo_id"
    t.integer  "schooltype_id",                 :null => false
    t.integer  "schoolboard_id",                :null => false
    t.string   "name",           :limit => 256, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schools", ["contactinfo_id"], :name => "contactinfo_id_fk2"
  add_index "schools", ["id"], :name => "schools_pk", :unique => true
  add_index "schools", ["name"], :name => "ak_name_schools", :unique => true
  add_index "schools", ["schoolboard_id"], :name => "schoolboard_id_fk"
  add_index "schools", ["schooltype_id"], :name => "schooltype_id_fk"

  create_table "schooltypes", :force => true do |t|
    t.string   "name",       :limit => 128, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schooltypes", ["id"], :name => "schooltypes_pk", :unique => true
  add_index "schooltypes", ["name"], :name => "ak_name_schoolty", :unique => true

  create_table "users", :force => true do |t|
    t.integer  "contactinfo_id"
    t.string   "last_name",              :limit => 64,                 :null => false
    t.string   "first_name",             :limit => 64,                 :null => false
    t.boolean  "gender"
    t.date     "birthday",                                             :null => false
    t.string   "email",                                :default => "", :null => false
    t.string   "encrypted_password",                   :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                      :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["contactinfo_id"], :name => "contactinfo_id_fk"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["id"], :name => "users_pk", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token", :unique => true
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

  add_foreign_key "agegroups", "categories", :name => "fk_agegroup_category__categori", :dependent => :restrict
  add_foreign_key "agegroups", "editions", :name => "fk_agegroup_edition_i_editions", :dependent => :restrict

  add_foreign_key "contactinfos", "cities", :name => "fk_contacti_city_id_cities", :dependent => :restrict

  add_foreign_key "payments", "registrations", :name => "fk_payments_registrat_registra", :dependent => :restrict
  add_foreign_key "payments", "users", :name => "fk_payments_user_id_users", :dependent => :restrict

  add_foreign_key "performances", "pieces", :name => "fk_performa_piece_id_pieces", :dependent => :restrict
  add_foreign_key "performances", "registrations", :name => "fk_performa_registrat_registra", :dependent => :restrict

  add_foreign_key "pieces", "composers", :name => "fk_pieces_composer__composer", :dependent => :restrict

  add_foreign_key "registrations", "categories", :name => "fk_registra_category__categori", :dependent => :restrict
  add_foreign_key "registrations", "editions", :name => "fk_registra_edition_i_editions", :dependent => :restrict
  add_foreign_key "registrations", "payments", :name => "fk_registra_registrat_payments", :column => "registration_id", :dependent => :restrict
  add_foreign_key "registrations", "schools", :name => "fk_registra_school_id_schools", :dependent => :restrict
  add_foreign_key "registrations", "users", :name => "fk_registra_user_owne_users", :column => "user_owner_id", :dependent => :restrict
  add_foreign_key "registrations", "users", :name => "fk_registra_user_teac_users", :column => "user_teacher_id", :dependent => :restrict

  add_foreign_key "registrations_users", "instruments", :name => "fk_registra_instrumen_instrume", :dependent => :restrict
  add_foreign_key "registrations_users", "registrations", :name => "fk_registra_registrat_registra", :dependent => :restrict
  add_foreign_key "registrations_users", "users", :name => "fk_registra_user_id_users", :dependent => :restrict

  add_foreign_key "roles_users", "roles", :name => "fk_roles_us_role_id_roles", :dependent => :restrict
  add_foreign_key "roles_users", "users", :name => "fk_roles_us_user_id_users", :dependent => :restrict

  add_foreign_key "schools", "contactinfos", :name => "fk_schools_contactin_contacti", :dependent => :restrict
  add_foreign_key "schools", "schoolboards", :name => "fk_schools_schoolboa_schoolbo", :dependent => :restrict
  add_foreign_key "schools", "schooltypes", :name => "fk_schools_schooltyp_schoolty", :dependent => :restrict

  add_foreign_key "users", "contactinfos", :name => "fk_users_contactin_contacti", :dependent => :restrict

end
