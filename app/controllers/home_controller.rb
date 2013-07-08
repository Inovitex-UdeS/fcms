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

    sheet_All.row(0).replace ["#", "Catégorie", "Instrument", "Durée", "Responsable", "Participants", "Bloc associé"] # On set les colonnes du workbook
    it = 1
    Registration.order(:category_id).each do |reg|
      tslot = reg.timeslot ? reg.timeslot.label : ""
      participants = reg.owner.name
      reg.users.all[1..-1].each do |u|
        participants << "\n" + "#{u.name}"
      end
      sheet_All.row(it).replace [reg.id, reg.category.name, reg.instruments.first.name, reg.duration, reg.owner.name, participants, tslot]
      it = it + 1
    end

    sheet_All.row(0).height = 18

    header_format = Spreadsheet::Format.new :color => :blue,
                                     :weight => :bold,
                                     :size => 12
    sheet_All.row(0).default_format = header_format


    ## OTHER SHEETS ##
    irow = 0
    Category.order(:name).each do |cat|
      sheet = excel_doc.create_worksheet  :name =>  cat.name.truncate(12) # sub tabs
      unless cat.timeslots.empty?
        cat.timeslots.each do |ts|
          sheet.row(irow).replace [ts.label]
          irow+=1
          sheet.row(irow).replace ["#", "Catégorie", "Instrument", "Durée", "Participants", "Âge"]
          irow+=1

          ts.registrations.each do |reg|
            participants = reg.owner.name
            reg.users.all[1..-1].each do |u|
              participants << "\n" + "#{u.name}"
            end
            sheet.row(irow).replace [reg.id, reg.category.name, reg.instruments.name, reg.duration, participants, 0]
            irow+=1
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
