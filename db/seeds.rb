#encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'

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

# Users
user1 = User.create(last_name: 'Gauthier', first_name: 'Jean-Philippe', gender: true, birthday: '1991-07-29', email: 'j-p.g@hotmail.com', password: 'password', contactinfo_id: contact1.id, confirmed_at: '2013-05-28 02:01:11.70392')
user2 = User.create(last_name: 'Paquette', first_name: 'Daniel', gender: true, birthday: '1980-05-12', email: 'dp@me.com', password: 'password', contactinfo_id: contact2.id,confirmed_at: '2013-05-28 02:01:11.70392')
user3 = User.create(last_name: 'Mine', first_name: 'Ad', gender: true, birthday: '1980-05-12', email: 'admin@admin.com', password: 'password', contactinfo_id: contact3.id,confirmed_at: '2013-05-28 02:01:11.70392')

# Roles
role1 = Role.create(name: 'participant')
role2 = Role.create(name: 'professeur')
role3 = Role.create(name: 'administrateur')

# Users_Roles
user1.roles << role1
user2.roles << role2
user3.roles << role3

# Edition
edition1 = Edition.create(year: 2007, limit_date: '2007-02-01')

# Categories
category1 = Category.create(name: 'Répertoire', nb_perf_min: 2, nb_perf_max: 4, description:'Categorie pour le repertoire de la guitare classique')
category2 = Category.create(name: 'Musique Canadienne', nb_perf_min: 2, nb_perf_max: 4, description:'')
category3 = Category.create(name: 'Festival', nb_perf_min: 2, nb_perf_max: 4, description:'')
category4 = Category.create(name: 'Récital', nb_perf_min: 2, nb_perf_max: 4, description:'')
category4 = Category.create(name: 'Musique de chambre ', nb_perf_min: 2, nb_perf_max: 4, description:'')
category5 = Category.create(name: 'Ensemble', nb_perf_min: 2, nb_perf_max: 4, description:'')
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
composer1 = Composer.create(name: 'SOR F.')
composer2 = Composer.create(name: 'SANZ G.')

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
registration1 = Registration.create(user_teacher_id: user2.id, user_owner_id: user1.id, school_id: School.where(:name => 'École secondaire de la Ruche').first.id, edition_id: edition1.id, category_id: category1.id, duration: 5)

# Payments
payment1 = Payment.create(user_id: user1.id, registration_id: registration1.id, mode: 'Cheque', no_chq: 1, name_chq: 'Jean-Philippe Gauthier', date_chq: '2007-05-05', depot_date: '2007-05-05', invoice: 'invoice1', cash: 38)

# Registrations_Users
registrationsuser1 = RegistrationsUser.create(instrument_id: instrument1.id, registration_id: registration1.id, user_id: user1.id)

# Performance
performance1 = Performance.create(piece_id: piece1.id, registration_id: registration1.id)
performance2 = Performance.create(piece_id: piece2.id, registration_id: registration1.id)