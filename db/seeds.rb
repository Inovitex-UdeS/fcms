#encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'

# Do not load all composers and pieces by default
load_all_composers_and_pieces = true

# Composers and pieces
if load_all_composers_and_pieces
  CSV.foreach("#{Rails.root}/tools/composer.csv", :headers => true) do |row|
    name = row[0].split(', ')
    if name.size > 1
      Composer.create(last_name: name[0], first_name: name[1], page_id: row[2])
    else
      Composer.create(last_name: name[0], page_id: row[2])
    end
  end
  CSV.foreach("#{Rails.root}/tools/piece.csv", :headers => true) do |row|
    Piece.create(title: row[1], composer_id: Composer.where(:page_id => row[0]).first.id, page_id: row[3])
  end
end

# Rooms
room1 = Room.create(capacity: 32, name: 'C1-3125', location: 'UdeS', description: 'Local de rencontre')
room2 = Room.create(capacity: 100, name: 'Sale Bandeen', location: 'CEGEP de Sherbrooke', description: 'Plus grande salle du festival')

# Cities
CSV.foreach("#{Rails.root}/tools/eastern_cities.csv") do |row|
  if !City.exists?(:name => row[1])
    City.create(name: row[1])
  end
end
CSV.foreach("#{Rails.root}/tools/eastern_schools.csv", :headers => true) do |row|
  if !City.exists?(:name => row[2])
    City.create(name: row[2])
  end
end

# ContactInfos
contact1 = Contactinfo.create(telephone: '819-843-7004', address: '112 rue rene', city_id: City.where(:name => 'Magog').first.id, province: 'Québec', postal_code: 'J1X3W5')
contact2 = Contactinfo.create(telephone: '111-111-1111', address: '1111 rue argyll', city_id: City.where(:name => 'Sherbrooke').first.id, province: 'Québec', postal_code: 'J1Z8V4')
contact3 = Contactinfo.create(telephone: '911', address: '007 thugstreet', city_id: City.where(:name => 'Sherbrooke').first.id, province: 'Québec',  postal_code: 'J1Z8V4')
contact4 = Contactinfo.create(telephone: '819-563-2050', address: '195 rue Marquette', city_id: City.where(:name => 'Sherbrooke').first.id, province: 'Québec', postal_code: 'J1H1L6')
contact5 = Contactinfo.create(telephone: '819-444-4444', address: '194 rue Marquette', city_id: City.where(:name => 'Sherbrooke').first.id, province: 'Québec', postal_code: 'J1H1L5')
contact6 = Contactinfo.create(telephone: '819-333-3333', address: '193 rue Marquette', city_id: City.where(:name => 'Sherbrooke').first.id, province: 'Québec', postal_code: 'J1H1L4')

# Users
user1 = User.create(last_name: 'Gauthier', first_name: 'Jean-Philippe', gender: true, birthday: '1991-07-29', email: 'j-p.g@hotmail.com', password: 'password', contactinfo_id: contact1.id, confirmed_at: '2013-05-28 02:01:11.70392')
user2 = User.create(last_name: 'Paquette', first_name: 'Daniel', gender: true, birthday: '1980-05-12', email: 'dp@me.com', password: 'password', contactinfo_id: contact2.id,confirmed_at: '2013-05-28 02:01:11.70392')
user3 = User.create(last_name: 'Mine', first_name: 'Ad', gender: true, birthday: '1980-05-12', email: 'admin@admin.com', password: 'password', contactinfo_id: contact3.id,confirmed_at: '2013-05-28 02:01:11.70392')
user4 = User.create(last_name: 'coderre', first_name: 'laurens', gender: true, birthday: '1991-07-29', email: 'lcoderre@me.com', password: 'password', contactinfo_id: contact1.id, confirmed_at: '2013-05-28 02:01:11.70392')
user5 = User.create(last_name: '2', first_name: 'Accompagnateur', gender: true, birthday: '1980-05-12', email: 'premier@accompagnateur.com', password: 'password', contactinfo_id: contact6.id,confirmed_at: '2013-05-28 02:01:11.70392')
user6 = User.create(last_name: '1', first_name: 'Juge', gender: true, birthday: '1980-05-12', email: 'premier@juge.com', password: 'password', contactinfo_id: contact5.id,confirmed_at: '2013-05-28 02:01:11.70392')

# Roles
role1 = Role.create(name: 'Participant')
role2 = Role.create(name: 'Professeur')
role3 = Role.create(name: 'Administrateur')
role4 = Role.create(name: 'Juge')
role5 = Role.create(name: 'Accompagnateur')

# Users_Roles
user1.roles << role1
user2.roles << role2
RolesUser.where('user_id='+user2.id.to_s + ' and role_id=' + role2.id.to_s).first.confirmed=true
user3.roles << role3
user4.roles << role1
user5.roles << role5
user6.roles << role4

# Edition
edition1 = Edition.create(year: 2007, start_date: '2007-05-01', end_date: '2007-05-06', limit_date: '2007-02-01')
Setting.create(key: 'current_edition_id', value: edition1.id)

# Categories
category1 = Category.create(name: 'Répertoire', nb_perf_min: 2, nb_perf_max: 4, description:'Categorie pour le repertoire de la guitare classique')
category2 = Category.create(name: 'Musique Canadienne', nb_perf_min: 2, nb_perf_max: 4, description:'')
category3 = Category.create(name: 'Festival', nb_perf_min: 2, nb_perf_max: 4, description:'')
category4 = Category.create(name: 'Récital', nb_perf_min: 2, nb_perf_max: 4, description:'')
category4 = Category.create(name: 'Musique de chambre ', nb_perf_min: 2, nb_perf_max: 4, description:'')
category5 = Category.create(name: 'Ensemble', nb_perf_min: 2, nb_perf_max: 4, description:'',group:true)
category6 = Category.create(name: 'Concertino', nb_perf_min: 2, nb_perf_max: 4, description:'')
category7 = Category.create(name: 'Concerto OSJS', nb_perf_min: 2, nb_perf_max: 4, description:'')

# AgeGroups
agegroup1 = Agegroup.create(edition_id: edition1.id, category_id: category1.id, min: '1992-07-01', max: '1990-07-01', fee: 33, max_duration: 7)# 7-9 ans
agegroup2 = Agegroup.create(edition_id: edition1.id, category_id: category1.id, min: '1992-07-01', max: '1990-07-01', fee: 36, max_duration: 7)# 10-11 ans
agegroup3 = Agegroup.create(edition_id: edition1.id, category_id: category1.id, min: '1992-07-01', max: '1990-07-01', fee: 38, max_duration: 7)# 12-13 ans
agegroup4 = Agegroup.create(edition_id: edition1.id, category_id: category1.id, min: '1992-07-01', max: '1990-07-01', fee: 39, max_duration: 7)# 14-16 ans
agegroup5 = Agegroup.create(edition_id: edition1.id, category_id: category1.id, min: '1992-07-01', max: '1990-07-01', fee: 40, max_duration: 7)# 17+ ans

agegroup6 = Agegroup.create(edition_id: edition1.id, category_id: category6.id, min: '1992-07-01', max: '1990-07-01', fee: 40, max_duration: 7)# 11- ans
agegroup7 = Agegroup.create(edition_id: edition1.id, category_id: category6.id, min: '1992-07-01', max: '1990-07-01', fee: 50, max_duration: 7)# 12-17 ans

agegroup8 = Agegroup.create(edition_id: edition1.id, category_id: category3.id, min: '1992-07-01', max: '1990-07-01', fee: 25, max_duration: 7) # 7-9 ans
agegroup9 = Agegroup.create(edition_id: edition1.id, category_id: category3.id, min: '1992-07-01', max: '1990-07-01', fee: 27, max_duration: 7) # 10-11 ans
agegroup10 = Agegroup.create(edition_id: edition1.id, category_id: category3.id, min: '1992-07-01', max: '1990-07-01', fee:30, max_duration: 7)# 12-13 ans
agegroup11 = Agegroup.create(edition_id: edition1.id, category_id: category3.id, min: '1992-07-01', max: '1990-07-01', fee:32, max_duration: 7)# 14-16 ans
agegroup12 = Agegroup.create(edition_id: edition1.id, category_id: category3.id, min: '1992-07-01', max: '1990-07-01', fee:35, max_duration: 7)# 17+ ans

agegroup13 = Agegroup.create(edition_id: edition1.id, category_id: category4.id, min: '1992-07-01', max: '1990-07-01', fee:55, max_duration: 7)# 15-16 ans
agegroup14 = Agegroup.create(edition_id: edition1.id, category_id: category4.id, min: '1992-07-01', max: '1990-07-01', fee:65, max_duration: 7)# 17+ ans

agegroup15 = Agegroup.create(edition_id: edition1.id, category_id: category5.id, min: '1992-07-01', max: '1990-07-01', fee:20, max_duration: 7)# 7-11 ans
agegroup16 = Agegroup.create(edition_id: edition1.id, category_id: category5.id, min: '1992-07-01', max: '1990-07-01', fee:25, max_duration: 7)# 12+ ans 

# Composers
composer1 = Composer.create(last_name: 'Barnby', first_name: 'Joseph')
composer2 = Composer.create(last_name: 'Bach', first_name: 'Johann Sebastian')

# Pieces
piece1 = Piece.create(composer_id: composer1.id, title: 'Theme et variations op.45 no 3')
piece2 = Piece.create(composer_id: composer2.id, title: 'Canarios')

# Schoolbaords
schoolboard1 = Schoolboard.create(name: 'Commission Scolaire des Sommets')

# Schooltypes
CSV.foreach("#{Rails.root}/tools/eastern_schools.csv", :headers => true) do |row|
  if !Schooltype.exists?(:name => row[1])
    Schooltype.create(name: row[1])
  end
end

# Schools
CSV.foreach("#{Rails.root}/tools/eastern_schools.csv", :headers => true) do |row|
  School.create(name: row[0], contactinfo_id: contact4.id, schooltype_id: Schooltype.where(:name => row[1]).first.id, schoolboard_id: schoolboard1.id)
end

# Instruments
instrument1 = Instrument.create(name: 'Guitare')

# Registration
registration1 = Registration.create(user_teacher_id: user2.id, user_owner_id: user1.id, school_id: School.find(1).id, edition_id: edition1.id, category_id: category1.id, duration: 5)
registration2 = Registration.create(user_teacher_id: user2.id, user_owner_id: user4.id, school_id: School.find(2).id, edition_id: edition1.id, category_id: category1.id, duration: 5)
registration3 = Registration.create(user_teacher_id: user2.id, user_owner_id: user4.id, school_id: School.find(3).id, edition_id: edition1.id, category_id: category1.id, duration: 5)
registration4 = Registration.create(user_teacher_id: user2.id, user_owner_id: user4.id, school_id: School.find(4).id, edition_id: edition1.id, category_id: category1.id, duration: 5)

# Payments
payment1 = Payment.create(user_id: user1.id, registration_id: registration1.id, mode: 'Cheque', no_chq: 1, name_chq: 'Jean-Philippe Gauthier', date_chq: '2007-05-05', depot_date: '2007-05-05', invoice: 'invoice1', cash: 38)

# Registrations_Users
registrationsuser1 = RegistrationsUser.create(instrument_id: instrument1.id, registration_id: registration1.id, user_id: user1.id)
registrationsuser2 = RegistrationsUser.create(instrument_id: instrument1.id, registration_id: registration2.id, user_id: user4.id)
registrationsuser3 = RegistrationsUser.create(instrument_id: instrument1.id, registration_id: registration3.id, user_id: user4.id)
registrationsuser4 = RegistrationsUser.create(instrument_id: instrument1.id, registration_id: registration4.id, user_id: user4.id)

# Performance
performance1 = Performance.create(piece_id: piece1.id, registration_id: registration1.id)
performance2 = Performance.create(piece_id: piece2.id, registration_id: registration1.id)
