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

ActiveRecord::Schema.define(:version => 20130522201536) do

  create_table "agegroups", :id => false, :force => true do |t|
    t.integer  "edition_id",                  :null => false
    t.integer  "id",                          :null => false
    t.integer  "class_id",                    :null => false
    t.date     "min"
    t.date     "max"
    t.string   "description",  :limit => 128
    t.integer  "fee"
    t.integer  "max_duration"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "agegroups", ["class_id"], :name => "class_id_fk"
  add_index "agegroups", ["edition_id", "id"], :name => "agegroups_pk", :unique => true
  add_index "agegroups", ["edition_id"], :name => "edition_id_fk"

  create_table "classes", :force => true do |t|
    t.string   "name",        :limit => 256, :null => false
    t.integer  "nb_perf_min",                :null => false
    t.integer  "nb_perf_max"
    t.text     "description"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "classes", ["id"], :name => "classes_pk", :unique => true

  create_table "composers", :force => true do |t|
    t.string "name", :limit => 256, :null => false
  end

  add_index "composers", ["id"], :name => "composers_pk", :unique => true

  create_table "configs", :id => false, :force => true do |t|
    t.string   "key",        :limit => 64,   :null => false
    t.string   "value",      :limit => 1024
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "configs", ["key"], :name => "configs_pk", :unique => true

  create_table "contests", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "contests", ["id"], :name => "contests_pk", :unique => true

  create_table "editions", :force => true do |t|
    t.integer  "year",       :null => false
    t.date     "limit_date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "editions", ["id"], :name => "editions_pk", :unique => true

  create_table "evaluations", :id => false, :force => true do |t|
    t.integer  "id",         :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "evaluations", ["id"], :name => "evaluations_pk", :unique => true

  create_table "instruments", :force => true do |t|
    t.string   "name",       :limit => 64, :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "instruments", ["id"], :name => "instruments_pk", :unique => true

  create_table "payments", :force => true do |t|
    t.integer  "user_id",                                                        :null => false
    t.integer  "registration_id",                                                :null => false
    t.string   "mode",            :limit => 64
    t.integer  "no_chq"
    t.string   "name_chq",        :limit => 1024
    t.date     "date_chq"
    t.date     "depot_date"
    t.string   "invoice",         :limit => 50
    t.decimal  "cash",                            :precision => 19, :scale => 2
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
  end

  add_index "payments", ["id"], :name => "payments_pk", :unique => true
  add_index "payments", ["registration_id"], :name => "payregistration_id_fk"
  add_index "payments", ["user_id"], :name => "payuser_id_fk"

  create_table "performances", :force => true do |t|
    t.integer  "piece_id",        :null => false
    t.integer  "registration_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "performances", ["id"], :name => "performances_pk", :unique => true
  add_index "performances", ["piece_id"], :name => "piece_id_fk"
  add_index "performances", ["registration_id"], :name => "perfregistration_id_fk"

  create_table "pieces", :force => true do |t|
    t.integer  "composer_id",                :null => false
    t.string   "title",       :limit => 256, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "pieces", ["composer_id"], :name => "composer_id_fk"
  add_index "pieces", ["id"], :name => "pieces_pk", :unique => true

  create_table "registrations", :force => true do |t|
    t.integer  "user_owner_id",   :null => false
    t.integer  "school_id"
    t.integer  "user_teacher_id", :null => false
    t.integer  "edition_id",      :null => false
    t.integer  "class_id",        :null => false
    t.integer  "duration",        :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "registrations", ["class_id"], :name => "regclass_id_fk"
  add_index "registrations", ["edition_id"], :name => "regedit_id_fk"
  add_index "registrations", ["id"], :name => "registrations_pk", :unique => true
  add_index "registrations", ["school_id"], :name => "school_id_fk"
  add_index "registrations", ["user_owner_id"], :name => "user_owner_id_fk"
  add_index "registrations", ["user_teacher_id"], :name => "user_teacher_id_fk"

  create_table "registrations_users", :id => false, :force => true do |t|
    t.integer  "instrument_id",   :null => false
    t.integer  "registration_id", :null => false
    t.integer  "user_id",         :null => false
    t.integer  "id",              :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "registrations_users", ["instrument_id", "registration_id", "user_id", "id"], :name => "registrations_users_pk", :unique => true
  add_index "registrations_users", ["instrument_id"], :name => "instrument_id_fk"
  add_index "registrations_users", ["registration_id"], :name => "registration_id_fk"
  add_index "registrations_users", ["user_id"], :name => "uruser_id_fk"

  create_table "roles", :force => true do |t|
    t.string   "name",       :limit => 256, :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "roles", ["id"], :name => "roles_pk", :unique => true

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "role_id",    :null => false
    t.integer  "user_id",    :null => false
    t.integer  "id",         :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "roles_users", ["role_id", "user_id"], :name => "roles_users_pk", :unique => true
  add_index "roles_users", ["role_id"], :name => "role_id_fk"
  add_index "roles_users", ["user_id"], :name => "user_id_fk"

  create_table "rooms", :force => true do |t|
    t.integer  "capacity"
    t.string   "name"
    t.string   "location",    :limit => 1024
    t.string   "description", :limit => 1024
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "rooms", ["id"], :name => "rooms_pk", :unique => true

  create_table "schoolboards", :force => true do |t|
    t.string   "name",       :limit => 128, :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "schoolboards", ["id"], :name => "schoolboards_pk", :unique => true

  create_table "schools", :force => true do |t|
    t.integer  "schoolboard_id"
    t.string   "name",           :limit => 256, :null => false
    t.string   "telephone",      :limit => 16,  :null => false
    t.string   "address",        :limit => 256
    t.string   "address2",       :limit => 256
    t.string   "city",           :limit => 256
    t.string   "province",       :limit => 256
    t.string   "postal_code",    :limit => 256
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "schools", ["id"], :name => "schools_pk", :unique => true
  add_index "schools", ["schoolboard_id"], :name => "schoolboard_id_fk"

  create_table "users", :force => true do |t|
    t.string   "last_name",              :limit => 64,                  :null => false
    t.string   "first_name",             :limit => 64,                  :null => false
    t.string   "telephone",              :limit => 16,                  :null => false
    t.string   "address",                :limit => 256
    t.string   "address2",               :limit => 256
    t.string   "city",                   :limit => 256
    t.string   "province",               :limit => 256
    t.boolean  "gender"
    t.string   "postal_code",            :limit => 256
    t.date     "birthday",                                              :null => false
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",                    :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["id"], :name => "users_pk", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  add_foreign_key "agegroups", "classes", :name => "fk_agegroup_class_id_classes", :dependent => :restrict
  add_foreign_key "agegroups", "editions", :name => "fk_agegroup_edition_i_editions", :dependent => :restrict

  add_foreign_key "payments", "registrations", :name => "fk_payments_payregist_registra", :dependent => :restrict
  add_foreign_key "payments", "users", :name => "fk_payments_payuser_i_users", :dependent => :restrict

  add_foreign_key "performances", "pieces", :name => "fk_performa_piece_id_pieces", :dependent => :restrict
  add_foreign_key "performances", "registrations", :name => "fk_performa_perfregis_registra", :dependent => :restrict

  add_foreign_key "pieces", "composers", :name => "fk_pieces_composer__composer", :dependent => :restrict

  add_foreign_key "registrations", "classes", :name => "fk_registra_regclass__classes", :dependent => :restrict
  add_foreign_key "registrations", "editions", :name => "fk_registra_regedit_i_editions", :dependent => :restrict
  add_foreign_key "registrations", "schools", :name => "fk_registra_school_id_schools", :dependent => :restrict
  add_foreign_key "registrations", "users", :name => "fk_registra_user_owne_users", :column => "user_owner_id", :dependent => :restrict
  add_foreign_key "registrations", "users", :name => "fk_registra_user_teac_users", :column => "user_teacher_id", :dependent => :restrict

  add_foreign_key "registrations_users", "instruments", :name => "fk_registra_instrumen_instrume", :dependent => :restrict
  add_foreign_key "registrations_users", "registrations", :name => "fk_registra_registrat_registra", :dependent => :restrict
  add_foreign_key "registrations_users", "users", :name => "fk_registra_uruser_id_users", :dependent => :restrict

  add_foreign_key "roles_users", "roles", :name => "fk_roles_us_role_id_roles", :dependent => :restrict
  add_foreign_key "roles_users", "users", :name => "fk_roles_us_user_id_users", :dependent => :restrict

  add_foreign_key "schools", "schoolboards", :name => "fk_schools_schoolboa_schoolbo", :dependent => :restrict

end
