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
load_all_composers_and_pieces = false

# Composers and pieces
if load_all_composers_and_pieces
  puts "Loading Composers..."
  CSV.foreach("#{Rails.root}/tools/composer.csv", :headers => true) do |row|
    array_name = row[0].split(', ')
    name = row[0]
    unless array_name.size == 1 # Filter CSV for names only fitting the format "LastName, FirstName1 Firstname2"
      lname = array_name.first
      fname = array_name.last

      fname_string = ""   # transfer "Johann Sebastian" --> "J.S."
      fname.split(' ').each do |tmp|
        tmp.split('-').each do |temp|
          fname_string += temp[0].to_s.upcase + "."
        end
      end
      # Redefine name, assuming all went well
      name = lname.upcase + ", " + fname_string

      Composer.find_or_create_by_name(name: name, page_id: row[2])
    end
  end


  puts "Loading Composers pieces..."
  CSV.foreach("#{Rails.root}/tools/piece.csv", :headers => true) do |row|
    comp = nil
    if (comp = Composer.find_by_page_id(row[0]))
      Piece.create(title: row[1], composer_id: comp.id, page_id: row[3])
    end

  end
end

# Rooms
Room.create(capacity: 200, name: 'Alfred-Des Rochers', location: 'Cégep de Sherbrooke', description: 'Très grande salle')
Room.create(capacity: 100, name: 'Bandeen', location: 'Université Bishop', description: 'Grande salle')
Room.create(capacity: 300, name: 'Centre Culturel', location: 'Université de Sherbrooke', description: 'Énorme Grande salle')

# Cities
puts "Loading Cities"
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

# Edition
Edition.create(year: 2012, start_date: '2012-05-01', end_date: '2012-05-06', limit_date: '2012-02-01', edit_limit_date: '2012-04-01')
edition2013 = Edition.create(year: 2013, start_date: '2013-05-01', end_date: '2013-05-06', limit_date: '2013-02-01', edit_limit_date: '2013-04-01')
edition = Edition.create(year: 2014, start_date: '2014-04-30', end_date: '2014-05-05', limit_date: '2014-02-20', edit_limit_date: '2014-04-15')
Setting.create(key: 'current_edition_id', value: edition.id)


puts "Loading default categories and settings..."
# Categories
category1 = Category.create(name: 'Répertoire', 					nb_participants:01,   accompanist:true,	description:"Les instrumentistes doivent interpréter deux pièces de caractère et de style contrastant. En chant, les candidats doivent présenter trois pièces.")
category2 = Category.create(name: 'Musique canadienne',   			nb_participants:01, accompanist:false,	description:"Cette classe, s'adresse à la fois aux solistes et aux participants en musique d'ensemble. Les participants doivent interpréter une oeuvre d'un compositeur canadien choisie au catalogue du Centre de musique canadienne (CMC) pour recevoir la bourse. La liste des œuvres autorisées se trouve sur le site du CMC : www.centremusique.ca Les oeuvres non inscrites au catalogue du CMC peuvent être acceptées dans cette catégorie, mais ne seront pas accessibles à la bource du CMC." )
category3 = Category.create(name: 'Festival',  						nb_participants:12, accompanist:false,	description:"Cette classe est ouverte aux élèves désirant participer au FCMS sans l’aspect compétition. Les participants peuvent présenter une ou deux pièces (inst11.id trois pièces). Les participants ne sont pas admissibles aux bourses d’excellence. Ils reçoivent toutefois commentaires, note et certificat de participation. Ils sont également admissibles aux bourses de participation données lors des concerts des finalistes.")
category4 = Category.create(name: 'Récital',  						nb_participants:12, accompanist:false,	description:"Cette classe s’adresse aux musiciens de 15 ans et plus qui participent au Concours de musique du Canada ou qui sont inscrits en interprétation (Cégep, Conservatoire ou Université). Les participants doivent interpréter deux ou trois pièces  de style et d’époque contrastants. Une de ces pièces doit être de l’époque baroque ou classique. Pour les instruments plus récents (percussions, saxophone..) le répertoire doit couvrir au moins deux périodes différentes. Les participants en chant classique doivent présenter trois à cinq pièces de styles et d’époque contrastants dans trois langues différentes.")
category5 = Category.create(name: 'Ensemble',		group:true , 	nb_participants:01, accompanist:false,	description:"Les ensembles devront être composés d’un maximum de 12 musiciens et/ou chanteurs. Les participants peuvent présenter une ou deux pièces. L’ensemble vocal peut présenter une à cinq pièces.")
category6 = Category.create(name: 'Concerto/Concertino',  			nb_participants:01, accompanist:false,	description:"Les participants doivent présenter un concertino ou un ou plusieurs mouvements de petit concerto non orchestrés. Ces participants ne sont pas éligibles au concours de l’OSJS.")
category7 = Category.create(name: 'Concerto OSJS',  				nb_participants:01, accompanist:false,	description:"Les membres du jury déterminent parmi les participants au concours les solistes de la prochaine saison de l'OSJS. Un premier prix sera décerné chez les 16 ans et moins, un autre chez les 17 ans et plus et un troisième prix sera décerné à un des participants, indépendamment de sa catégorie. Les gagnants d'une édition ne pourront se présenter l'année suivante. Ils pourront toutefois se présenter à nouveau par la suite. Les participants doivent présenter un ou plusieurs mouvements d'un concerto ou d'une oeuvre concertante. En inst11.id, les candidats peuvent présenter un ou deux airs d'opéra, d'oratorio, ou toute oeuvre pour voix et orchestre. Les résultats de la catégorie Concerto seront dévoilés lors du concert des finalistes, dimanche le 5 mai et non à la fin des auditions, comme dans les autres catégories.œ")

# Répertoire
agegroup1 = Agegroup.create(edition_id: edition.id, category_id: category1.id, min:7, max: 9, fee: 33,  max_duration: 5)# (7 à 9 ans)
agegroup2 = Agegroup.create(edition_id: edition.id, category_id: category1.id, min:10, max:11 , fee: 36, max_duration:7)# (10 à 11 ans)
agegroup3 = Agegroup.create(edition_id: edition.id, category_id: category1.id, min:12, max:13 , fee: 38, max_duration:10)#(12 à 13 ans)
agegroup4 = Agegroup.create(edition_id: edition.id, category_id: category1.id, min:14, max:16 , fee: 39, max_duration:15)#(14 à 16 ans)
agegroup5 = Agegroup.create(edition_id: edition.id, category_id: category1.id, min:17, max:99 , fee: 40, max_duration:15)#(17 ans et plus)

# Concerto/concertino
agegroup6 = Agegroup.create(edition_id: edition.id, category_id: category6.id, min: 0, max: 11, fee: 40, max_duration: 15)# 11- ans
agegroup7 = Agegroup.create(edition_id: edition.id, category_id: category6.id, min: 12 , max: 17, fee: 50, max_duration: 20)# 12-17 ans

# Festival
agegroup8 =  Agegroup.create(edition_id: edition.id, category_id: category3.id, min: 07, max: 9, fee: 25, max_duration: 5) # 7-9 ans
agegroup9 =  Agegroup.create(edition_id: edition.id, category_id: category3.id, min: 10, max: 11, fee: 27, max_duration: 7) # 10-11 ans
agegroup10 = Agegroup.create(edition_id: edition.id, category_id: category3.id, min: 12, max: 13, fee: 30, max_duration: 10)# 12-13 ans
agegroup11 = Agegroup.create(edition_id: edition.id, category_id: category3.id, min: 14, max: 16, fee: 32, max_duration: 15)# 14-16 ans
agegroup12 = Agegroup.create(edition_id: edition.id, category_id: category3.id, min: 17, max: 99, fee: 35, max_duration: 15)# 17+ ans

# Récital
agegroup13 = Agegroup.create(edition_id: edition.id, category_id: category4.id, min: 15, max: 16, fee:55, max_duration: 20)# 15-16 ans
agegroup14 = Agegroup.create(edition_id: edition.id, category_id: category4.id, min: 17, max: 99, fee:65, max_duration: 30)# 17+ ans

# Ensemble
agegroup15 = Agegroup.create(edition_id: edition.id, category_id: category5.id, min: 07, max: 9, fee: 20, max_duration: 5) # (7 à 9 ans)
agegroup16 = Agegroup.create(edition_id: edition.id, category_id: category5.id, min: 10, max: 11, fee: 20, max_duration: 7) # (10 à 11 ans)
agegroup17 = Agegroup.create(edition_id: edition.id, category_id: category5.id, min: 12, max: 13, fee: 25, max_duration: 10)# (12 à 13 ans)
agegroup18 = Agegroup.create(edition_id: edition.id, category_id: category5.id, min: 14, max: 16, fee: 25, max_duration: 15)# (14 à 16 ans)
agegroup19 = Agegroup.create(edition_id: edition.id, category_id: category5.id, min: 17, max: 99, fee: 25, max_duration: 15)# (17 ans et plus)

# Concerto OSJS
agegroup20 = Agegroup.create(edition_id: edition.id, category_id: category7.id, min: 00, max: 16, fee:55, max_duration: 30)# (16 ans et moins)
agegroup21 = Agegroup.create(edition_id: edition.id, category_id: category7.id, min: 17, max: 99, fee:65, max_duration: 30)# (17 ans et plus)

# Musique canadienne
agegroup27 = Agegroup.create(edition_id: edition.id, category_id: category2.id, min: 07, max: 9, fee: 33, max_duration: 5) # (7 à 9 ans)
agegroup28 = Agegroup.create(edition_id: edition.id, category_id: category2.id, min: 10, max: 11, fee: 36, max_duration: 7) # (10 à 11 ans)
agegroup29 = Agegroup.create(edition_id: edition.id, category_id: category2.id, min: 12, max: 13, fee: 38, max_duration: 10)# (12 à 13 ans)
agegroup30 = Agegroup.create(edition_id: edition.id, category_id: category2.id, min: 14, max: 16, fee: 39, max_duration: 15)# (14 à 16 ans)
agegroup31 = Agegroup.create(edition_id: edition.id, category_id: category2.id, min: 17, max: 99, fee: 40, max_duration: 15)# (17 ans et plus)

puts "Loading school data..."
# Schools
CSV.foreach("#{Rails.root}/tools/eastern_schools.csv", :headers => true) do |row|

  if !Schoolboard.exists?(:name => row[14])
    Schoolboard.create(name: row[14])
  end

  if !Schooltype.exists?(:name => row[1])
    Schooltype.create(name: row[1])
  end

  school_contact = Contactinfo.create(telephone: row[3], address: row[16], city_id: City.find_by_name(row[2]).id, province: 'Québec', postal_code: row[18].gsub(/\s+/, ""))
  School.create(name: row[0], contactinfo_id: school_contact.id,  schooltype_id: Schooltype.find_by_name(row[1]).id, schoolboard_id: Schoolboard.find_by_name(row[14]).id)
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
inst12 = Instrument.create(name: "Chant classique")
inst13 = Instrument.create(name: "Comédie musicale")
inst14 = Instrument.create(name: "Clavecin")
inst15 = Instrument.create(name: "Trompette")
inst17 = Instrument.create(name: "Flûte traversière")
inst17 = Instrument.create(name: "Harpe")


# Roles
part_role = Role.create(name: 'Participant')
teach_role = Role.create(name: 'Professeur')
admin_role = Role.create(name: 'Administrateur')
judge_role = Role.create(name: 'Juge')
accom_role = Role.create(name: 'Accompagnateur')


# ContactInfos
contact_admin = Contactinfo.create(telephone: '819-843-7004', address: '112 rue de l\'administrateur', city_id: City.find_by_name('Sherbrooke').id, province: 'Québec', postal_code: 'J1X3W5')
contact_part1 = Contactinfo.create(telephone: '819-412-1233', address: '112 rue du participant 1', city_id: City.find_by_name('Danville').id, province: 'Québec', postal_code: 'J1X0V5')
contact_part2 = Contactinfo.create(telephone: '819-412-1123', address: '112 rue du participant 2', city_id: City.find_by_name('Asbestos').id, province: 'Québec', postal_code: 'J1Q123')
contact_teach = Contactinfo.create(telephone: '819-123-2543', address: '112 rue du professeur', city_id: City.find_by_name('Magog').id, province: 'Québec', postal_code: 'J1X0V6')
contact_accom = Contactinfo.create(telephone: '819-547-7689', address: '112 rue de l\'accompagnateur', city_id: City.find_by_name('Austin').id, province: 'Québec', postal_code: 'J3X4D6')
contact_judge = Contactinfo.create(telephone: '819-678-5467', address: '112 rue du juge', city_id: City.find_by_name('Compton').id, province: 'Québec', postal_code: 'J53D4F')

# Users
admin = User.create(last_name: 'Tremblay', first_name: 'Madeleine', gender: false, birthday: '1960-05-29', email: 'admin@admin.com', password: 'password', contactinfo_id: contact_admin.id, confirmed_at: '2013-05-28 02:01:11.70392')
part1 = User.create(last_name: 'Icipant1', first_name: 'Part', gender: true, birthday: '2000-02-12', email: 'user1@iuse.com', password: 'passuser1', contactinfo_id: contact_part1.id, confirmed_at: '2013-05-28 02:01:11.70392')
part2 = User.create(last_name: 'Icipant2', first_name: 'Part', gender: true, birthday: '1996-03-21', email: 'user2@iuse.com', password: 'passuser2', contactinfo_id: contact_part2.id, confirmed_at: '2013-05-28 02:01:11.70392')
teach = User.create(last_name: 'Esseur', first_name: 'Prof', gender: true, birthday: '1988-07-29', email: 'teacher@iteach.com', password: 'passteach', contactinfo_id: contact_teach.id, confirmed_at: '2013-05-28 02:01:11.70392')
accom = User.create(last_name: 'Pagnateur', first_name: 'Accom', gender: true, birthday: '1991-02-2', email: 'accomp@iaccomp.com', password: 'passaccomp', contactinfo_id: contact_accom.id, confirmed_at: '2013-05-28 02:01:11.70392')
judge = User.create(last_name: 'Ge', first_name: 'Ju', gender: true, birthday: '1971-03-20', email: 'judge@ijudge.com', password: 'passjudge', contactinfo_id: contact_judge.id, confirmed_at: '2013-05-28 02:01:11.70392')

# Users_Roles
admin.roles << admin_role
part1.roles << part_role
part2.roles << part_role
teach.roles << teach_role
accom.roles << accom_role
judge.roles << judge_role
RolesUser.where("user_id=#{judge.id} AND role_id=#{judge_role.id}").first.update_attribute(:confirmed, true)

unless false  #test Laurens pour exportation excel
             # Composers
  composer1 = Composer.create(name: 'SOR F.')
  composer2 = Composer.create(name: 'SANZ G.')

# Pieces
  piece1 = Piece.create(composer_id: composer1.id, title: 'Theme et variations op.45 no 3')
  piece2 = Piece.create(composer_id: composer2.id, title: 'Canarios')

# Registration
  registration1 = Registration.create(user_teacher_id: teach.id, user_owner_id: part1.id, school_id: School.find(1).id, edition_id: edition2013.id, category_id: category5.id, duration: 5)
  registration2 = Registration.create(user_teacher_id: teach.id, user_owner_id: part2.id, school_id: School.find(2).id, edition_id: edition2013.id, category_id: category5.id, duration: 5)
  registration3 = Registration.create(user_teacher_id: teach.id, user_owner_id: part2.id, school_id: School.find(3).id, edition_id: edition2013.id, category_id: category5.id, duration: 5)
  registration4 = Registration.create(user_teacher_id: teach.id, user_owner_id: part2.id, school_id: School.find(4).id, edition_id: edition2013.id, category_id: category5.id, duration: 5)

# Registrations_Users
  registrationsuser1 = RegistrationsUser.create(instrument_id: inst1.id, registration_id: registration1.id, user_id: part1.id)
  registrationsuser2 = RegistrationsUser.create(instrument_id: inst1.id, registration_id: registration2.id, user_id: part2.id)
  registrationsuser3 = RegistrationsUser.create(instrument_id: inst1.id, registration_id: registration3.id, user_id: part2.id)
  registrationsuser4 = RegistrationsUser.create(instrument_id: inst1.id, registration_id: registration4.id, user_id: part2.id)

# Performance
  performance1 = Performance.create(piece_id: Piece.find(1).id, registration_id: registration1.id)
  performance2 = Performance.create(piece_id: Piece.find(2).id, registration_id: registration1.id)
end

DEMO_PLANIF = true
if DEMO_PLANIF
  puts "Loading 2013 Excel Data..."

  demo_edition = Edition.find_by_year(2013)

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
      if usr.first
        usr = usr.first
        else
          usr = User.create(last_name: row[6].strip, first_name: row[5].strip, gender: true, birthday: "#{1985+rand(15)}-07-29", email: count.to_s+"@inovitex.com", password: 'password', contactinfo_id: Contactinfo.find(1+rand(3)).id, confirmed_at: '2013-05-28 02:01:11.70392')
          usr.roles << part_role
        end

      reg = Registration.create(user_teacher_id: teach.id, user_owner_id: usr.id, school_id: sch.id, edition_id: demo_edition.id, category_id: cat.id, duration: row[7].to_i, age_max: 6+rand(20))
      RegistrationsUser.create(instrument_id: instr.id, registration_id: reg.id, user_id: usr.id)

    else
      prenoms = row[5].split('|').map {|x| x.strip}
      noms = row[6].split('|').map {|x| x.strip}

      usr = User.where("first_name='#{prenoms[0].to_s}' and last_name='#{noms[0].to_s}'")

      if usr.first
        usr = usr.first
      else
        usr = User.create(last_name: noms[0].to_s, first_name: prenoms[0].to_s, gender: true, birthday: "#{1985+rand(15)}-07-29", email: count.to_s+"@inovitex.com", password: 'password', contactinfo_id: Contactinfo.find(1+rand(3)).id, confirmed_at: '2013-05-28 02:01:11.70392')
        usr.roles << part_role

      end
      reg = Registration.create(user_teacher_id: teach.id, user_owner_id: usr.id, school_id: sch.id, edition_id: demo_edition.id, category_id: cat.id, duration: row[7].to_i, age_max: 6+rand(20))


      prenoms.each_index { |i|
        tmp = nil
        tmp = User.where("first_name='#{prenoms[i].to_s}' and last_name='#{noms[i].to_s}'")

        if tmp.first
          tmp = tmp.first
        else
          tmp = User.create(last_name: noms[i], first_name: prenoms[i], gender: true, birthday: "#{1985+rand(15)}-07-29", email: count.to_s+"-"+i.to_s+"@inovitex.com", password: 'password', contactinfo_id: Contactinfo.find(1+rand(3)).id, confirmed_at: '2013-05-28 02:01:11.70392')
          tmp.roles << part_role
        end
        RegistrationsUser.create(instrument_id: instr.id, registration_id: reg.id, user_id: tmp.id)
      }

    end
  end

  ts1 = Timeslot.create(label: "Piano XX-YY ans", edition_id: demo_edition.id, category_id: category1.id, duration:101)
  ts2 = Timeslot.create(label: "Autres 75 et moins", edition_id: demo_edition.id, category_id: category1.id, duration:57)

  Registration.where("id IN (1, 20, 21, 22, 23, 24, 25, 27, 28, 29, 30, 31, 32)").each do |r|
    r.update_attribute(:timeslot_id, ts1.id)
  end

  Registration.where("id IN (13, 14, 15, 16, 17, 18, 19)").each do |r|
    r.update_attribute(:timeslot_id, ts2.id)
  end
end
