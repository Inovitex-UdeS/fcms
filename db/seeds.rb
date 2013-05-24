# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Edition
edition1 = Edition.create(year: 2007, limit_date: '2007-02-01')

# Categories
category1 = Category.create(name: 'Guitare repertoire', nb_perf_min: 2, nb_perf_max: 4, description:'Categorie pour le repertoire de la guitare classique')

# AgeGroups
agegroup1 = Agegroup.create(edition_id: edition1.id, category_id: category1.id, min: '1992-07-01', max: '1990-07-01', fee: 38, max_duration: 7)

# Composers
composer1 = Composer.create(name: 'SOR F.')
composer2 = Composer.create(name: 'SANZ G.')

# Pieces
piece1 = Piece.create(composer_id: composer1.id, title: 'Theme et variations op.45 no 3')
piece2 = Piece.create(composer_id: composer2.id, title: 'Canarios')

# Schoolbaords
schoolboard1 = Schoolboard.create(name: 'Commission Scolaire des Sommets')

# School
school1 = School.create(schoolboard_id: schoolboard1.id, name: 'Seminaire de Sherbrooke', telephone: '819-563-2050', address: '195 rue Marquette', city: 'Sherbrooke', province: 'Quebec', postal_code: 'J1H1L6')

# Instruments
instrument1 = Instrument.create(name: 'Guitare')

# Roles
role1 = Role.create(name: 'participant')
role2 = Role.create(name: 'professeur')
role3 = Role.create(name: 'administrateur')

# Users
user1 = User.create(last_name: 'Gauthier', first_name: 'Jean-Philippe', telephone: '819-843-7004', address: '112 rue rene', city: 'Magog', province: 'Quebec', gender: true, postal_code: 'J1X3W5', birthday: '1991-07-29', email: 'j-p.g@hotmail.com', password: 'password')
user2 = User.create(last_name: 'Paquette', first_name: 'Daniel', telephone: '111-111-1111', address: '1111 rue argyll', city: 'Sherbrooke', province: 'Quebec', gender: true, postal_code: 'J1Z8V4', birthday: '1980-05-12', email: 'dp@me.com', password: 'password')

# Users_Roles
userrole1 = RolesUser.create(user_id: user1.id, role_id: role1.id)
userrole2 = RolesUser.create(user_id: user2.id, role_id: role2.id)

# Registration
registration1 = Registration.create(user_teacher_id: user2.id, user_owner_id: user1.id, school_id: school1.id, edition_id: edition1.id, category_id: category1.id, duration: 5)

# Payments
payment1 = Payment.create(user_id: user1.id, registration_id: registration1.id, mode: 'Cheque', no_chq: 1, name_chq: 'Jean-Philippe Gauthier', date_chq: '2007-05-05', depot_date: '2007-05-05', invoice: 'invoice1', cash: 38)

# Registrations_Users
registrationsuser1 = RegistrationsUser.create(instrument_id: instrument1.id, registration_id: registration1.id, user_id: user1.id)

# Performance
performance1 = Performance.create(piece_id: piece1.id, registration_id: registration1.id)
performance2 = Performance.create(piece_id: piece2.id, registration_id: registration1.id)
