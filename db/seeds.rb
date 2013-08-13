#encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

TESTS_CUCUMBER = false

# Do not load all composers and pieces by default
load_all_composers_and_pieces = true

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

# Home message
Setting.create(key: 'home_message', value: 'Bienvenue sur l&#39;application web du Festival-Concours de Musique de Sherbrooke.<br /><br />Cette application a &eacute;t&eacute; d&eacute;velopp&eacute;e pour permettre aux participants de s&#39;inscrire en ligne, pour ainsi permettre &agrave; l&#39;organisation de planifier simplement et efficacement chaque &eacute;dition.<br />&nbsp;<div style="text-align:center"><img alt="" src="/assets/logo-site.png" style="height:141px; width:300px" /></div><div><br />Le Festival-concours de musique de Sherbrooke et de la r&eacute;gion de l&rsquo;Estrie a &eacute;t&eacute; cr&eacute;&eacute; en 1989 par madame Th&eacute;r&egrave;se Lupien, professeure de chant au coll&egrave;ge de Sherbrooke, avec l&rsquo;aide de coll&egrave;gues et amis. Cr&eacute;&eacute; pour offrir une occasion aux musiciens de la r&eacute;gion de participer &agrave; un concours, le Festival a connu depuis une croissance constante et est devenu un &eacute;v&eacute;nement bien &eacute;tabli dans la r&eacute;gion de l&rsquo;Estrie.<br />&nbsp;<br />En l&rsquo;an 2000, la Fondation sherbrookoise pour la musique inc. prend la rel&egrave;ve jusqu&rsquo;en janvier 2003, o&ugrave; un groupe de professeurs de musique de l&rsquo;Estrie se voit confier l&rsquo;organisation du FCMS.<br /><br />C&rsquo;est avec passion et d&eacute;vouement que les membres actuels du Conseil d&rsquo;administration tentent de perp&eacute;tuer cette exp&eacute;rience musicale pour les musiciens en formation classique de la r&eacute;gion de l&rsquo;Estrie.</div>')

puts "Loading default categories and settings..."
# Categories
category1 = Category.create(name: 'Répertoire',           nb_participants:  1, accompanist: true,  nb_piece_lim1: 2, nb_piece_lim2: 3, description: "Les instrumentistes doivent interpr&eacute;ter <strong>deux pi&egrave;ces</strong> de caract&egrave;re et de style contrastant.<br />En chant, les candidats doivent pr&eacute;senter <strong>trois pi&egrave;ces</strong>.")
category2 = Category.create(name: 'Musique canadienne',   nb_participants:  1, accompanist: false, nb_piece_lim1: 1, nb_piece_lim2: 1, description: "Cette classe, s&#39;adresse &agrave; la fois aux solistes et aux participants en musique d&#39;ensemble. Les participants doivent interpr&eacute;ter une oeuvre d&#39;un compositeur canadien choisie au catalogue du Centre de musique canadienne (CMC) pour recevoir la bourse. La liste des &oelig;uvres autoris&eacute;es se trouve sur le site du CMC : <a href=\"http://www.centremusique.ca\">www.centremusique.ca</a>.<br />Les oeuvres non inscrites au catalogue du CMC peuvent &ecirc;tre accept&eacute;es dans cette cat&eacute;gorie, mais ne seront pas accessibles &agrave; la bource du CMC." )
category3 = Category.create(name: 'Festival',             nb_participants:  1, accompanist: false, nb_piece_lim1: 2, nb_piece_lim2: 3, description: "Cette classe est ouverte aux élèves désirant participer au FCMS sans l’aspect compétition. Les participants peuvent présenter une ou deux pièces (chant trois pièces). Les participants ne sont pas admissibles aux bourses d’excellence. Ils reçoivent toutefois commentaires, note et certificat de participation. Ils sont également admissibles aux bourses de participation données lors des concerts des finalistes.")
category4 = Category.create(name: 'Récital',              nb_participants:  1, accompanist: false, nb_piece_lim1: 3, nb_piece_lim2: 5, description: "Cette classe s&rsquo;adresse aux musiciens de 15 ans et plus qui participent au Concours de musique du Canada ou qui sont inscrits en interpr&eacute;tation (C&eacute;gep, Conservatoire ou Universit&eacute;). Les participants doivent interpr&eacute;ter deux ou trois pi&egrave;ces de style et d&rsquo;&eacute;poque contrastants. <strong>Une de ces pi&egrave;ces doit &ecirc;tre de l&rsquo;&eacute;poque baroque ou classique. </strong>Pour les instruments plus r&eacute;cents (percussions, saxophone...), le r&eacute;pertoire doit couvrir au moins deux p&eacute;riodes diff&eacute;rentes. Les participants en chant classique doivent pr&eacute;senter trois &agrave; cinq pi&egrave;ces de styles et d&rsquo;&eacute;poque contrastants dans trois langues diff&eacute;rentes.")
category5 = Category.create(name: 'Ensemble', group:true, nb_participants: 12, accompanist: false, nb_piece_lim1: 2, nb_piece_lim2: 5, description: "Les ensembles devront être composés d’un maximum de 12 musiciens et/ou chanteurs. Les participants peuvent présenter une ou deux pièces. L’ensemble vocal peut présenter une à cinq pièces.")
category6 = Category.create(name: 'Concerto/Concertino',  nb_participants:  1, accompanist: false, nb_piece_lim1: 1, nb_piece_lim2: 1, description: "Les participants doivent présenter un concertino ou un ou plusieurs mouvements de petit concerto non orchestrés. Ces participants ne sont pas éligibles au concours de l’OSJS.")
category7 = Category.create(name: 'Concerto OSJS',        nb_participants:  1, accompanist: false, nb_piece_lim1: 1, nb_piece_lim2: 1, description: "Les membres du jury d&eacute;terminent parmi les participants au concours les solistes de la prochaine saison de l&#39;OSJS. Un premier prix sera d&eacute;cern&eacute; chez les 16 ans et moins, un autre chez les 17 ans et plus et un troisi&egrave;me prix sera d&eacute;cern&eacute; &agrave; un des participants, ind&eacute;pendamment de sa cat&eacute;gorie. Les gagnants d&#39;une &eacute;dition ne pourront se pr&eacute;senter l&#39;ann&eacute;e suivante. Ils pourront toutefois se pr&eacute;senter &agrave; nouveau par la suite.<br />Les participants doivent pr&eacute;senter un ou plusieurs mouvements d&#39;un concerto ou d&#39;une oeuvre concertante. En chant, les candidats peuvent pr&eacute;senter un ou deux airs d&#39;op&eacute;ra, d&#39;oratorio, ou toute oeuvre pour voix et orchestre.<br />Les r&eacute;sultats de la cat&eacute;gorie Concerto seront d&eacute;voil&eacute;s lors du concert des finalistes, dimanche le 5 mai et non &agrave; la fin des auditions, comme dans les autres cat&eacute;gories.")

# Répertoire
agegroup1 = Agegroup.create(edition_id: edition.id, description: '7-9 ans',        category_id: category1.id, min:7, max: 9, fee: 33,  max_duration: 5)
agegroup2 = Agegroup.create(edition_id: edition.id, description: '10-11 ans',      category_id: category1.id, min:10, max:11 , fee: 36, max_duration:7)
agegroup3 = Agegroup.create(edition_id: edition.id, description: '12-13 ans',      category_id: category1.id, min:12, max:13 , fee: 38, max_duration:10)
agegroup4 = Agegroup.create(edition_id: edition.id, description: '14-16 ans',      category_id: category1.id, min:14, max:16 , fee: 39, max_duration:15)
agegroup5 = Agegroup.create(edition_id: edition.id, description: '17 ans et plus', category_id: category1.id, min:17, max:99 , fee: 40, max_duration:15)

# Concerto/concertino
agegroup6 = Agegroup.create(edition_id: edition.id, description: '11 ans et moins', category_id: category6.id, min: 0, max: 11, fee: 40, max_duration: 15)
agegroup7 = Agegroup.create(edition_id: edition.id, description: '12-17 ans',       category_id: category6.id, min: 12 , max: 17, fee: 50, max_duration: 20)

# Festival
agegroup8 =  Agegroup.create(edition_id: edition.id, description: '7-9 ans',        category_id: category3.id, min:  7, max: 9, fee: 25, max_duration: 5)
agegroup9 =  Agegroup.create(edition_id: edition.id, description: '10-11 ans',      category_id: category3.id, min: 10, max: 11, fee: 27, max_duration: 7)
agegroup10 = Agegroup.create(edition_id: edition.id, description: '12-13 ans',      category_id: category3.id, min: 12, max: 13, fee: 30, max_duration: 10)
agegroup11 = Agegroup.create(edition_id: edition.id, description: '14-16 ans',      category_id: category3.id, min: 14, max: 16, fee: 32, max_duration: 15)
agegroup12 = Agegroup.create(edition_id: edition.id, description: '17 ans et plus', category_id: category3.id, min: 17, max: 99, fee: 35, max_duration: 15)

# Récital
agegroup13 = Agegroup.create(edition_id: edition.id, description: '15-16 ans',      category_id: category4.id, min: 15, max: 16, fee:55, max_duration: 20)
agegroup14 = Agegroup.create(edition_id: edition.id, description: '17 ans et plus', category_id: category4.id, min: 17, max: 99, fee:65, max_duration: 30)

# Ensemble
agegroup15 = Agegroup.create(edition_id: edition.id, description: '7-9 ans',        category_id: category5.id, min: 07, max: 9, fee: 20, max_duration: 5)
agegroup16 = Agegroup.create(edition_id: edition.id, description: '10-11 ans',      category_id: category5.id, min: 10, max: 11, fee: 20, max_duration: 7)
agegroup17 = Agegroup.create(edition_id: edition.id, description: '12-13 ans',      category_id: category5.id, min: 12, max: 13, fee: 25, max_duration: 10)
agegroup18 = Agegroup.create(edition_id: edition.id, description: '14-16 ans',      category_id: category5.id, min: 14, max: 16, fee: 25, max_duration: 15)
agegroup19 = Agegroup.create(edition_id: edition.id, description: '17 ans et plus', category_id: category5.id, min: 17, max: 99, fee: 25, max_duration: 15)

# Concerto OSJS
agegroup20 = Agegroup.create(edition_id: edition.id, description: '16 ans et moins', category_id: category7.id, min: 00, max: 16, fee:55, max_duration: 30)
agegroup21 = Agegroup.create(edition_id: edition.id, description: '17 ans et plus',  category_id: category7.id, min: 17, max: 99, fee:65, max_duration: 30)

# Musique canadienne
agegroup27 = Agegroup.create(edition_id: edition.id, description: '7-9 ans',        category_id: category2.id, min:  7, max: 9, fee: 33, max_duration: 5)
agegroup28 = Agegroup.create(edition_id: edition.id, description: '10-11 ans',      category_id: category2.id, min: 10, max: 11, fee: 36, max_duration: 7)
agegroup29 = Agegroup.create(edition_id: edition.id, description: '12-13 ans',      category_id: category2.id, min: 12, max: 13, fee: 38, max_duration: 10)
agegroup30 = Agegroup.create(edition_id: edition.id, description: '14-16 ans',      category_id: category2.id, min: 14, max: 16, fee: 39, max_duration: 15)
agegroup31 = Agegroup.create(edition_id: edition.id, description: '17 ans et plus', category_id: category2.id, min: 17, max: 99, fee: 40, max_duration: 15)

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
# Guitars
inst1  = Instrument.create(name: 'Guitare')

# Keyboards
Instrument.create name: 'Piano'
Instrument.create name: 'Orgue'
Instrument.create name: 'Clavecin'
Instrument.create name: 'Clavicorde'

# Strings
Instrument.create name: 'Guitare basse'
Instrument.create name: 'Mandoline'
Instrument.create name: 'Banjo'
Instrument.create name: 'Cithare'
Instrument.create name: 'Harpe'

# Violin family
Instrument.create name: 'Violon'
Instrument.create name: 'Violon alto'
Instrument.create name: 'Violoncelle'
Instrument.create name: 'Contrebasse'

# Woodwinds
Instrument.create name: 'Flûte'
Instrument.create name: 'Flûte traversière'
Instrument.create name: 'Cor anglais'
Instrument.create name: 'Hautbois'
Instrument.create name: 'Piccolo'
Instrument.create name: 'Clarinette'
Instrument.create name: 'Saxophone'

# Voice
Instrument.create name: 'Chant classique'
Instrument.create name: 'Comédie musicale'

# Brass
Instrument.create name: 'Trompette'
Instrument.create name: 'Trombone'
Instrument.create name: 'Tuba'
Instrument.create name: 'Cor français'

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

if TESTS_CUCUMBER  #test Laurens pour exportation excel
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

if TESTS_CUCUMBER
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
