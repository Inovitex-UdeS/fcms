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
edition1 = Edition.create(year: 2012, start_date: '2007-05-01', end_date: '2007-05-06', limit_date: '2007-02-01')
Setting.create(key: 'current_edition_id', value: edition1.id)

# Categories
category1 = Category.create(name: 'Répertoire', 					nb_participants:01, accompanyist:true,	description:"Les instrumentistes doivent interpréter deux pièces de caractère et de style contrastant. En inst11.id, les candidats doivent présenter trois pièces.")
category2 = Category.create(name: 'Musique canadienne',   			nb_participants:01, accompanyist:false,	description:"Cette classe, s'adresse à la fois aux solistes et aux participants en musique d'ensemble. Les participants doivent interpréter une oeuvre d'un compositeur canadien choisie au catalogue du Centre de musique canadienne (CMC) pour recevoir la bourse. La liste des œuvres autorisées se trouve sur le site du CMC : www.centremusique.ca Les oeuvres non inscrites au catalogue du CMC peuvent être acceptées dans cette catégorie, mais ne seront pas accessibles à la bource du CMC." )
category3 = Category.create(name: 'Festival',  						nb_participants:12, accompanyist:false,	description:"Cette classe est ouverte aux élèves désirant participer au FCMS sans l’aspect compétition. Les participants peuvent présenter une ou deux pièces (inst11.id trois pièces). Les participants ne sont pas admissibles aux bourses d’excellence. Ils reçoivent toutefois commentaires, note et certificat de participation. Ils sont également admissibles aux bourses de participation données lors des concerts des finalistes.")
category4 = Category.create(name: 'Récital',  						nb_participants:12, accompanyist:false,	description:"Cette classe s’adresse aux musiciens de 15 ans et plus qui participent au Concours de musique du Canada ou qui sont inscrits en interprétation (Cégep, Conservatoire ou Université). Les participants doivent interpréter deux ou trois pièces  de style et d’époque contrastants. Une de ces pièces doit être de l’époque baroque ou classique. Pour les instruments plus récents (percussions, saxophone..) le répertoire doit couvrir au moins deux périodes différentes. Les participants en inst12.id doivent présenter trois à cinq pièces de styles et d’époque contrastants dans trois langues différentes.")
category5 = Category.create(name: 'Ensemble',		group:true , 	nb_participants:01, accompanyist:false,	description:"Les ensembles devront être composés d’un maximum de 12 musiciens et/ou inst11.ideurs. Les participants peuvent présenter une ou deux pièces. L’ensemble vocal peut présenter une à cinq pièces.")
category6 = Category.create(name: 'Concerto/Concertino',  			nb_participants:01, accompanyist:false,	description:"Les participants doivent présenter un concertino ou un ou plusieurs mouvements de petit concerto non orchestrés. Ces participants ne sont pas éligibles au concours de l’OSJS.")
category7 = Category.create(name: 'Concerto OSJS',  				nb_participants:01, accompanyist:false,	description:"Les membres du jury déterminent parmi les participants au concours les solistes de la prochaine saison de l'OSJS. Un premier prix sera décerné chez les 16 ans et moins, un autre chez les 17 ans et plus et un troisième prix sera décerné à un des participants, indépendamment de sa catégorie. Les gagnants d'une édition ne pourront se présenter l'année suivante. Ils pourront toutefois se présenter à nouveau par la suite. Les participants doivent présenter un ou plusieurs mouvements d'un concerto ou d'une oeuvre concertante. En inst11.id, les candidats peuvent présenter un ou deux airs d'opéra, d'oratorio, ou toute oeuvre pour voix et orchestre. Les résultats de la catégorie Concerto seront dévoilés lors du concert des finalistes, dimanche le 5 mai et non à la fin des auditions, comme dans les autres catégories.œ")

# Répertoire
agegroup1 = Agegroup.create(edition_id: edition1.id, category_id: category1.id, min:7, max: 9, fee: 33,  max_duration: 5)# (7 à 9 ans)
agegroup2 = Agegroup.create(edition_id: edition1.id, category_id: category1.id, min:10, max:11 , fee: 36, max_duration:7)# (10 à 11 ans)
agegroup3 = Agegroup.create(edition_id: edition1.id, category_id: category1.id, min:12, max:13 , fee: 38, max_duration:10)#(12 à 13 ans)
agegroup4 = Agegroup.create(edition_id: edition1.id, category_id: category1.id, min:14, max:16 , fee: 39, max_duration:15)#(14 à 16 ans)
agegroup5 = Agegroup.create(edition_id: edition1.id, category_id: category1.id, min:17, max:99 , fee: 40, max_duration:15)#(17 ans et plus)

# Concerto/concertino
agegroup6 = Agegroup.create(edition_id: edition1.id, category_id: category6.id, min: 0, max: 11, fee: 40, max_duration: 15)# 11- ans
agegroup7 = Agegroup.create(edition_id: edition1.id, category_id: category6.id, min: 12 , max: 17, fee: 50, max_duration: 20)# 12-17 ans

# Festival
agegroup8 =  Agegroup.create(edition_id: edition1.id, category_id: category3.id, min: 07, max: 9, fee: 25, max_duration: 5) # 7-9 ans
agegroup9 =  Agegroup.create(edition_id: edition1.id, category_id: category3.id, min: 10, max: 11, fee: 27, max_duration: 7) # 10-11 ans
agegroup10 = Agegroup.create(edition_id: edition1.id, category_id: category3.id, min: 12, max: 13, fee: 30, max_duration: 10)# 12-13 ans
agegroup11 = Agegroup.create(edition_id: edition1.id, category_id: category3.id, min: 14, max: 16, fee: 32, max_duration: 15)# 14-16 ans
agegroup12 = Agegroup.create(edition_id: edition1.id, category_id: category3.id, min: 17, max: 99, fee: 35, max_duration: 15)# 17+ ans

# Récital
agegroup13 = Agegroup.create(edition_id: edition1.id, category_id: category4.id, min: 15, max: 16, fee:55, max_duration: 20)# 15-16 ans
agegroup14 = Agegroup.create(edition_id: edition1.id, category_id: category4.id, min: 17, max: 99, fee:65, max_duration: 30)# 17+ ans

# Ensemble
agegroup15 = Agegroup.create(edition_id: edition1.id, category_id: category5.id, min: 07, max: 9, fee: 20, max_duration: 5) # (7 à 9 ans)
agegroup16 = Agegroup.create(edition_id: edition1.id, category_id: category5.id, min: 10, max: 11, fee: 20, max_duration: 7) # (10 à 11 ans)
agegroup17 = Agegroup.create(edition_id: edition1.id, category_id: category5.id, min: 12, max: 13, fee: 25, max_duration: 10)# (12 à 13 ans)
agegroup18 = Agegroup.create(edition_id: edition1.id, category_id: category5.id, min: 14, max: 16, fee: 25, max_duration: 15)# (14 à 16 ans)
agegroup19 = Agegroup.create(edition_id: edition1.id, category_id: category5.id, min: 17, max: 99, fee: 25, max_duration: 15)# (17 ans et plus)

# Concerto OSJS
agegroup20 = Agegroup.create(edition_id: edition1.id, category_id: category7.id, min: 00, max: 16, fee:55, max_duration: 30)# (16 ans et moins)
agegroup21 = Agegroup.create(edition_id: edition1.id, category_id: category7.id, min: 17, max: 99, fee:65, max_duration: 30)# (17 ans et plus)

# Musique canadienne
agegroup27 = Agegroup.create(edition_id: edition1.id, category_id: category2.id, min: 07, max: 9, fee: 33, max_duration: 5) # (7 à 9 ans)
agegroup28 = Agegroup.create(edition_id: edition1.id, category_id: category2.id, min: 10, max: 11, fee: 36, max_duration: 7) # (10 à 11 ans)
agegroup29 = Agegroup.create(edition_id: edition1.id, category_id: category2.id, min: 12, max: 13, fee: 38, max_duration: 10)# (12 à 13 ans)
agegroup30 = Agegroup.create(edition_id: edition1.id, category_id: category2.id, min: 14, max: 16, fee: 39, max_duration: 15)# (14 à 16 ans)
agegroup31 = Agegroup.create(edition_id: edition1.id, category_id: category2.id, min: 17, max: 99, fee: 40, max_duration: 15)# (17 ans et plus)


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
inst1  = Instrument.create(name: "Guitare")
inst2  = Instrument.create(name: "Piano")
inst3  = Instrument.create(name: "Flûte")
inst5  = Instrument.create(name: "Violon")
inst6  = Instrument.create(name: "Violoncelle")
inst7  = Instrument.create(name: "Clarinette")
inst8  = Instrument.create(name: "Contrebasse")
inst9  = Instrument.create(name: "Trombonne")
inst10 = Instrument.create(name: "Cello")
inst11 = Instrument.create(name: "Chant")
inst12 = Instrument.create(name: "Chant classique")
inst13 = Instrument.create(name: "Comédie musicale")
inst14 = Instrument.create(name: "Clavecin")
inst15 = Instrument.create(name: "Trompette")
inst16 = Instrument.create(name: "Alto")
inst17 = Instrument.create(name: "Flûte traversière")
inst17 = Instrument.create(name: "Harpe")

# Registration
registration1 = Registration.create(user_teacher_id: user2.id, user_owner_id: user1.id, school_id: School.find(1).id, edition_id: edition1.id, category_id: category1.id, duration: 5)
registration2 = Registration.create(user_teacher_id: user2.id, user_owner_id: user4.id, school_id: School.find(2).id, edition_id: edition1.id, category_id: category1.id, duration: 5)
registration3 = Registration.create(user_teacher_id: user2.id, user_owner_id: user4.id, school_id: School.find(3).id, edition_id: edition1.id, category_id: category1.id, duration: 5)
registration4 = Registration.create(user_teacher_id: user2.id, user_owner_id: user4.id, school_id: School.find(4).id, edition_id: edition1.id, category_id: category1.id, duration: 5)

# Payments
payment1 = Payment.create(user_id: user1.id, registration_id: registration1.id, mode: 'Cheque', no_chq: 1, name_chq: 'Jean-Philippe Gauthier', date_chq: '2007-05-05', depot_date: '2007-05-05', invoice: 'invoice1', cash: 38)

# Registrations_Users
registrationsuser1 = RegistrationsUser.create(instrument_id: inst1.id, registration_id: registration1.id, user_id: user1.id)
registrationsuser2 = RegistrationsUser.create(instrument_id: inst1.id, registration_id: registration2.id, user_id: user4.id)
registrationsuser3 = RegistrationsUser.create(instrument_id: inst1.id, registration_id: registration3.id, user_id: user4.id)
registrationsuser4 = RegistrationsUser.create(instrument_id: inst1.id, registration_id: registration4.id, user_id: user4.id)

# Performance
performance1 = Performance.create(piece_id: piece1.id, registration_id: registration1.id)
performance2 = Performance.create(piece_id: piece2.id, registration_id: registration1.id)

### THIS IS FUCKING BULLSHIT.  C'est à prendre seulement pour les tests!

DEMO_PLANIF = true
if DEMO_PLANIF


  count = 0
  CSV.foreach("#{Rails.root}/tools/test.csv") do |row|
    row = row.to_s[2..-3]
    row = row.to_s.split(";")

    #puts "nbr:#{row[0]}	 cat:#{row[2]}	inst:#{row[3]}	age:#{row[4]}	fname:#{row[5]}	nom:#{row[6]}"
    usr = nil
    cat = nil
    reg = nil
    contact = nil

    count +=1

    sch = School.find(1)
    cat = Category.find_by_name(row[2].strip)
    instr = Instrument.find_by_name(row[3].strip.capitalize)

    if (row[0]=="1")
      usr = User.where("first_name='#{row[5].strip}' and last_name='#{row[6].strip}'")
      usr.first ?
          usr = usr.first :
          usr = User.create(last_name: row[6].strip, first_name: row[5].strip, gender: true, birthday: '1991-07-29', email: count.to_s+"@inovitex.com", password: 'password', contactinfo_id: contact1.id, confirmed_at: '2013-05-28 02:01:11.70392')
      reg = Registration.create(user_teacher_id: user2.id, user_owner_id: usr.id, school_id: sch.id, edition_id: edition1.id, category_id: 1, duration: row[7].to_i)
      RegistrationsUser.create(instrument_id: instr.id, registration_id: reg.id, user_id: usr.id)

    else
      prenoms = row[5].split('|').map {|x| x.strip}
      noms = row[6].split('|').map {|x| x.strip}

      usr = User.where("first_name='#{prenoms[0].to_s}' and last_name='#{noms[0].to_s}'")
      usr.first ?
          usr = usr.first :
          usr = User.create(last_name: noms[0].to_s, first_name: prenoms[0].to_s, gender: true, birthday: '1991-07-29', email: count.to_s+"@inovitex.com", password: 'password', contactinfo_id: contact1.id, confirmed_at: '2013-05-28 02:01:11.70392')


      reg = Registration.create(user_teacher_id: user2.id, user_owner_id: usr.id, school_id: sch.id, edition_id: edition1.id, category_id: 1, duration: row[7].to_i)


      prenoms.each_index { |i|
        tmp = nil
        tmp = User.where("first_name='#{prenoms[i].to_s}' and last_name='#{noms[i].to_s}'")
        tmp.first ?
            tmp = tmp.first :
            tmp = User.create(last_name: noms[i], first_name: prenoms[i], gender: true, birthday: '1991-07-29', email: count.to_s+"-"+i.to_s+"@inovitex.com", password: 'password', contactinfo_id: contact1.id, confirmed_at: '2013-05-28 02:01:11.70392')

        RegistrationsUser.create(instrument_id: instr.id, registration_id: reg.id, user_id: tmp.id)
      }

    end
  end
end