class HomeController < ApplicationController

  def index

    # Will call index view by default
  end

  def ProduceExcel
    # Beau guide : http://spreadsheet.rubyforge.org/files/GUIDE_txt.html
    require 'spreadsheet'


    excel_doc = Spreadsheet::Workbook.new # Créer le book!


    ## MAIN SHEET ##
    sheet_All = excel_doc.create_worksheet  :name => "TOUT" # On crée un TAB Excel avec un nom :)

    sheet_All.row(0).replace ["#", "Catégorie", "Bloc associé", "Participants", "Instrument",  "Durée","École", "Courriel", "#Tel", "#civil","ville", "code postal",  ] # On set les colonnes du workbook
    it = 1
    Registration.order(:category_id)[0..160].each do |reg|
      if (it==36)
        bam = 3
      end
      reg_users =  reg_instruments =  tslot =  participants = nil
      courriels =   tels = civils =  cities =  postals = nil

      reg_users = reg.users
      reg_instruments = reg.instruments.order(:user_id)

      tslot = reg.timeslot ? reg.timeslot.label : ""
      participants = reg_users.first.name
      courriels = reg_users.first.email
      tels = reg_users.first.contactinfo.telephone
      civils = reg_users.first.contactinfo.address
      cities = reg_users.first.contactinfo.city.name
      postals = reg_users.first.contactinfo.postal_code

      reg.users.all[1..-1].each do |u|
        participants << "\n" + "#{u.name}"
        courriels << "\n" + "#{u.email}"
        tels << "\n" + "#{u.contactinfo.telephone}"
        civils << "\n" + "#{u.contactinfo.address}"
        cities << "\n" + "#{u.contactinfo.city.name}"
        postals << "\n" + "#{u.contactinfo.postal_code}"
      end

      instruments = reg_instruments.first.name
      reg_instruments[1..-1].each do |i|
        instruments << "\n" + "#{i.name}"
      end

      #[reg.id, reg.category.name, tslot, participants, instruments,  reg.duration,  courriels, tels, civils, cities, postals ]
      sheet_All.row(it).replace [  reg.id, participants,  tels,  cities ]
      it = it + 1
    end

    sheet_All.row(0).height = 18

    header_format = Spreadsheet::Format.new :color => :blue,
                                            :weight => :bold,
                                            :size => 12
    sheet_All.row(0).default_format = header_format

    unless false
      ## OTHER SHEETS ##
      Category.order(:name).each do |cat|
        unless cat.timeslots.empty?
          irow = 0
          sheet = excel_doc.create_worksheet  :name =>  cat.name.truncate(12) # sub tabs
          cat.timeslots.each do |ts|
            sheet.row(irow).replace [ts.label]
            irow+=1
            sheet.row(irow).replace ["#", "Catégorie", "Participants", "Instrument",  "Durée", "Âge"]
            irow+=1

            ts.registrations.each do |reg|
              reg_users = reg.users
              reg_instruments = reg.instruments.order(:user_id)
              participants =reg_users.first.name
              instruments = reg_instruments.first.name
              reg_users[1..-1].each do |u|
                participants << "\n" + "#{u.name}"
              end

              reg_instruments[1..-1].each do |i|
                instruments << "\n" + "#{i.name}"
              end
              sheet.row(irow).replace [reg.id, reg.category.name, participants, instruments, reg.duration,  reg.age_max]
              irow+=1
            end
          end
        end
      end
    end




    # Sauvegarder le fichier excel
    spreadsheet = StringIO.new
    excel_doc.write spreadsheet
    send_data spreadsheet.string, :filename => "FCMS-Inscriptions-2012.xls", :type =>  "application/vnd.ms-excel"
  end

end
