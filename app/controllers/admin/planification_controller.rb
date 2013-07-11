class Admin::PlanificationController < ApplicationController
  def index
  end

  def categories
    selected_category = Category.find(params[:id])
    registrations = Registration.all(:joins => :users, :conditions => {:category_id => params[:id]})

    render :json => {
        :id => selected_category.id,
        :name => selected_category.name,
        :registrations =>
            registrations.as_json(:include => :users
        )
    }
  end



  def ProduceExcel
    # Beau guide : http://spreadsheet.rubyforge.org/files/GUIDE_txt.html
    require 'spreadsheet'

    excel_doc = Spreadsheet::Workbook.new # Créer le book!


    ## MAIN SHEET ##

    header_format = Spreadsheet::Format.new :weight => :bold,
                                            :size => 12
    timeslot_format = Spreadsheet::Format.new :weight => :bold,
                                              :size => 12

    sheet_All = excel_doc.create_worksheet  :name => "TOUT" # On crée un TAB Excel avec un nom :)

    sheet_All.row(0).replace ["#", "Catégorie", "Bloc associé", "Participants", "Instrument",  "Durée", "Courriel", "#Tel", "Rue","Ville", "Code postal", "École" ] # On set les colonnes du workbook
    sheet_All.row(0).each_index do |i|
      sheet_All.column(i).width = sheet_All.row(0).at(i).to_s.length+3
    end

    it = 1
    Registration.order(:category_id)[0..-1].each do |reg|
      instruments = participants = courriels = tels = ""
      civils = cities = postals = ""

      tslot = reg.timeslot ? reg.timeslot.label : ""

      reg.users.each do |u|
        participants += "#{u.name}" + "\n"
        courriels +=  "#{u.email}"+"\n"
        ctact = Contactinfo.find(u.contactinfo.id)
        tels +=     "#{ctact.telephone}"  + "\n"
        civils +=   "#{ctact.address}"+ "\n"
        cities +=   "#{ctact.city.name}"+ "\n"
        postals +=  "#{ctact.postal_code}" + "\n"
      end

      reg.instruments.order(:user_id).each do |i|
        instruments +=  "#{i.name}" + "\n"
      end

      sheet_All.row(it).replace [reg.id, reg.category.name, tslot, participants, instruments,  reg.duration,  courriels, tels, civils, cities, postals, reg.school.name ]
      it = it + 1
    end

    sheet_All.row(0).default_format = header_format

    unless false
      ## OTHER SHEETS ##
      Category.order(:name).each do |cat|
        unless cat.timeslots.empty?
          irow = 0
          # Create subtab
          sheet = excel_doc.create_worksheet  :name =>  cat.name.truncate(12)
          # Adjust column width
          headers = ["", "#", "Catégorie", "Participants", "Instruments",  "Durée", "Âge"]
          sheet.column(0).width = 20
          headers[1..-1].each_index do |i|
            sheet.column(i).width = headers.at(i).to_s.length+3
          end

          # Fill sheet
          cat.timeslots.each do |ts|
            sheet.row(irow).replace [ts.label]
            sheet.row(irow).default_format = timeslot_format
            irow+=1
            sheet.row(irow).replace headers

            sheet.row(irow).default_format = header_format
            irow+=1

            ts.registrations.each do |reg|
              participants = instruments = ''

              reg.users.each do |u|
                participants += "#{u.name}" + "\n"
              end

              reg.instruments.order(:user_id).each do |i|
                instruments += "#{i.name}" + "\n"
              end

              sheet.row(irow).replace ['', reg.id, reg.category.name, participants, instruments, reg.duration,  reg.age_max]
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
