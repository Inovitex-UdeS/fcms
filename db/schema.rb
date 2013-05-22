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

ActiveRecord::Schema.define(:version => 0) do

  create_table "USER", :force => true do |t|
    t.string  "last_name",   :limit => 64,  :null => false
    t.string  "first_name",  :limit => 64,  :null => false
    t.string  "telephone",   :limit => 16,  :null => false
    t.string  "address",     :limit => 256
    t.string  "address2",    :limit => 256
    t.string  "city",        :limit => 256
    t.string  "province",    :limit => 256
    t.boolean "gender"
    t.string  "postal_code", :limit => 256
    t.date    "birthday",                   :null => false
  end

  add_index "USER", ["id"], :name => "user_pk", :unique => true

  create_table "agegroup", :id => false, :force => true do |t|
    t.integer "edition_id",                                                 :null => false
    t.integer "id",                                                         :null => false
    t.integer "class_id",                                                   :null => false
    t.date    "min"
    t.date    "max"
    t.string  "description",  :limit => 128
    t.decimal "fee",                         :precision => 19, :scale => 2
    t.integer "max_duration"
  end

  add_index "agegroup", ["class_id"], :name => "class_id_fk"
  add_index "agegroup", ["edition_id", "id"], :name => "agegroup_pk", :unique => true
  add_index "agegroup", ["edition_id"], :name => "edition_id_fk"

  create_table "class", :force => true do |t|
    t.string  "name",        :limit => 256, :null => false
    t.integer "nb_perf_min",                :null => false
    t.integer "nb_perf_max"
    t.text    "description"
  end

  add_index "class", ["id"], :name => "class_pk", :unique => true

  create_table "composer", :force => true do |t|
    t.string "name", :limit => 256, :null => false
  end

  add_index "composer", ["id"], :name => "composer_pk", :unique => true

  create_table "config", :id => false, :force => true do |t|
    t.string "key",   :limit => 64,   :null => false
    t.string "value", :limit => 1024
  end

  add_index "config", ["key"], :name => "config_pk", :unique => true

  create_table "contest", :force => true do |t|
  end

  add_index "contest", ["id"], :name => "contest_pk", :unique => true

  create_table "edition", :force => true do |t|
    t.integer "year",       :null => false
    t.date    "limit_date"
  end

  add_index "edition", ["id"], :name => "edition_pk", :unique => true

  create_table "evaluation", :id => false, :force => true do |t|
    t.integer "id", :null => false
  end

  add_index "evaluation", ["id"], :name => "evaluation_pk", :unique => true

  create_table "instrument", :force => true do |t|
    t.string "name", :limit => 64, :null => false
  end

  add_index "instrument", ["id"], :name => "instrument_pk", :unique => true

  create_table "payment", :force => true do |t|
    t.integer "user_id",                                                        :null => false
    t.integer "registration_id",                                                :null => false
    t.string  "mode",            :limit => 64
    t.integer "no_chq"
    t.string  "name_chq",        :limit => 1024
    t.date    "date_chq"
    t.date    "depot_date"
    t.string  "invoice",         :limit => 50
    t.decimal "cash",                            :precision => 19, :scale => 2
  end

  add_index "payment", ["id"], :name => "payment_pk", :unique => true
  add_index "payment", ["registration_id"], :name => "payregistration_id_fk"
  add_index "payment", ["user_id"], :name => "payuser_id_fk"

  create_table "performance", :force => true do |t|
    t.integer "piece_id",                      :null => false
    t.integer "registration_id"
    t.string  "column_4",        :limit => 10
  end

  add_index "performance", ["id"], :name => "performance_pk", :unique => true
  add_index "performance", ["piece_id"], :name => "piece_id_fk"
  add_index "performance", ["registration_id"], :name => "perfregistration_id_fk"

  create_table "piece", :force => true do |t|
    t.integer "composer_id",                :null => false
    t.string  "title",       :limit => 256, :null => false
  end

  add_index "piece", ["composer_id"], :name => "composer_id_fk"
  add_index "piece", ["id"], :name => "piece_pk", :unique => true

  create_table "registration", :force => true do |t|
    t.integer "user_owner_id",   :null => false
    t.integer "school_id"
    t.integer "user_teacher_id", :null => false
    t.integer "edit_id",         :null => false
    t.integer "class_id",        :null => false
    t.integer "duration",        :null => false
  end

  add_index "registration", ["class_id"], :name => "regclass_id_fk"
  add_index "registration", ["edit_id"], :name => "regedit_id_fk"
  add_index "registration", ["id"], :name => "registration_pk", :unique => true
  add_index "registration", ["school_id"], :name => "school_id_fk"
  add_index "registration", ["user_owner_id"], :name => "user_owner_id_fk"
  add_index "registration", ["user_teacher_id"], :name => "user_teacher_id_fk"

  create_table "role", :force => true do |t|
    t.string "name", :limit => 256, :null => false
  end

  add_index "role", ["id"], :name => "role_pk", :unique => true

  create_table "room", :force => true do |t|
    t.integer "capacity"
    t.string  "name"
    t.string  "location",    :limit => 1024
    t.string  "description", :limit => 1024
  end

  add_index "room", ["id"], :name => "room_pk", :unique => true

  create_table "school", :force => true do |t|
    t.integer "schoolboard_id"
    t.string  "name",           :limit => 256, :null => false
    t.string  "telephone",      :limit => 16,  :null => false
    t.string  "address",        :limit => 256
    t.string  "address2",       :limit => 256
    t.string  "city",           :limit => 256
    t.string  "province",       :limit => 256
    t.string  "postal_code",    :limit => 256
  end

  add_index "school", ["id"], :name => "school_pk", :unique => true
  add_index "school", ["schoolboard_id"], :name => "schoolboard_id_fk"

  create_table "schoolboard", :force => true do |t|
    t.string "name", :limit => 128, :null => false
  end

  add_index "schoolboard", ["id"], :name => "schoolboard_pk", :unique => true

  create_table "userregistration", :id => false, :force => true do |t|
    t.integer "instrument_id",   :null => false
    t.integer "registration_id", :null => false
    t.integer "user_id",         :null => false
    t.integer "id",              :null => false
  end

  add_index "userregistration", ["instrument_id", "registration_id", "user_id", "id"], :name => "userregistration_pk", :unique => true
  add_index "userregistration", ["instrument_id"], :name => "instrument_id_fk"
  add_index "userregistration", ["registration_id"], :name => "registration_id_fk"
  add_index "userregistration", ["user_id"], :name => "uruser_id_fk"

  create_table "userrole", :id => false, :force => true do |t|
    t.integer "role_id", :null => false
    t.integer "user_id", :null => false
    t.integer "id",      :null => false
  end

  add_index "userrole", ["role_id", "user_id", "id"], :name => "userrole_pk", :unique => true
  add_index "userrole", ["role_id"], :name => "rrole_id_fk"
  add_index "userrole", ["user_id"], :name => "user_id_fk"

  add_foreign_key "agegroup", "class", :name => "fk_agegroup_class_id_class", :column => "class_id", :dependent => :restrict
  add_foreign_key "agegroup", "edition", :name => "fk_agegroup_edition_i_edition", :dependent => :restrict

  add_foreign_key "payment", "USER", :name => "fk_payment_payuser_i_user", :column => "user_id", :dependent => :restrict
  add_foreign_key "payment", "registration", :name => "fk_payment_payregist_registra", :dependent => :restrict

  add_foreign_key "performance", "piece", :name => "fk_performa_piece_id_piece", :dependent => :restrict
  add_foreign_key "performance", "registration", :name => "fk_performa_perfregis_registra", :dependent => :restrict

  add_foreign_key "piece", "composer", :name => "fk_piece_composer__composer", :dependent => :restrict

  add_foreign_key "registration", "USER", :name => "fk_registra_user_owne_user", :column => "user_owner_id", :dependent => :restrict
  add_foreign_key "registration", "USER", :name => "fk_registra_user_teac_user", :column => "user_teacher_id", :dependent => :restrict
  add_foreign_key "registration", "class", :name => "fk_registra_regclass__class", :column => "class_id", :dependent => :restrict
  add_foreign_key "registration", "edition", :name => "fk_registra_regedit_i_edition", :column => "edit_id", :dependent => :restrict
  add_foreign_key "registration", "school", :name => "fk_registra_school_id_school", :dependent => :restrict

  add_foreign_key "school", "schoolboard", :name => "fk_school_schoolboa_schoolbo", :dependent => :restrict

  add_foreign_key "userregistration", "USER", :name => "fk_userregi_uruser_id_user", :column => "user_id", :dependent => :restrict
  add_foreign_key "userregistration", "instrument", :name => "fk_userregi_instrumen_instrume", :dependent => :restrict
  add_foreign_key "userregistration", "registration", :name => "fk_userregi_registrat_registra", :dependent => :restrict

  add_foreign_key "userrole", "USER", :name => "fk_userrole_user_id_user", :column => "user_id", :dependent => :restrict
  add_foreign_key "userrole", "role", :name => "fk_userrole_rrole_id_role", :dependent => :restrict

end
