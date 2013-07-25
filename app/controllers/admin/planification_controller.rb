#encoding: utf-8
class Admin::PlanificationController < ApplicationController
  before_filter :prevent_non_admin

  def index
  end

  def show
    # Get the selected category
    selected_category = Category.find(params[:id])

    # Find the timeslots for this category
    timeslots = Timeslot.all(
        :conditions => {
            :category_id => selected_category.id,
            :edition_id => Setting.find_by_key('current_edition_id').value
        },
        :include => [ :registrations ]
    )

    # Find the registrations for this category
    registrations = Registration.all(
        :conditions => {
            :category_id => selected_category.id,
            :edition_id => Setting.find_by_key('current_edition_id').value
        },
        :include => [
            :registrations_users => [ :user, :instrument ],
            :performances => [ :piece => [ :composer ] ]
        ]
    )

    # Put all registrations in an array for easy indexation
    registrations_array = []
    registrations.each do |reg|
      registrations_array.insert reg.id, reg.as_simple_json
    end

    # Render everything
    render :json => {
        :id => selected_category.id,
        :name => selected_category.name,
        :timeslots => timeslots.as_json,
        :registrations => registrations_array.as_json
    }
  end

  def ProduceExcel
    # Beau guide : http://spreadsheet.rubyforge.org/files/GUIDE_txt.html
    require 'spreadsheet'

    excel_doc = Spreadsheet::Workbook.new # Créer le book!


    ## MAIN SHEET ##

    header_format = Spreadsheet::Format.new :weight => :bold, :size => 12
    timeslot_format = Spreadsheet::Format.new :weight => :bold, :size => 12

    sheet_All = excel_doc.create_worksheet  :name => "TOUT" # On crée un TAB Excel avec un nom :)

    # On set les colonnes du workbook
    sheet_All.row(0).replace  ["#", "Catégorie", "Bloc associé", "Participants", "Instrument",  "Durée", "Compositeur", "Oeuvre", "Courriel", "#Tel",
                               "Rue","Ville", "Code postal", "Institution scolaire","École musique",  "Professeur","Courriel Prof", "Montant à payer", "Payé","#chq","Date Paiment",  "Résultat", "Note" ]

    sheet_All.row(0).each_index do |i|
      sheet_All.column(i).width = sheet_All.row(0).at(i).to_s.length+3
    end

    it = 1
    Registration.order(:category_id)[0..-1].each do |reg|
      instruments = participants = courriels = tels = composers = pieces = ""
      civils = cities = postals = teacher =  teacher_email = ""
      montant = 0

      if (group = Agegroup.where(edition_id: Setting.find_by_key('current_edition_id').value , :category_id=> reg.category).where("#{reg.age_max} BETWEEN min and max").first)
        montant = group.fee * reg.users.count
      end

      tslot = reg.timeslot ? reg.timeslot.label : ""
      teacher = reg.teacher ? reg.teacher.name : ""
      teacher_email = reg.teacher ? reg.teacher.email : ""

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

      reg.performances.order(:id).each do |p|
        composers +=  "#{p.piece.composer.name}" + "\n"
        pieces +=  "#{p.piece.title}" + "\n"
      end

      sheet_All.row(it).replace       [reg.id, reg.category.name, tslot, participants, instruments,  reg.duration, composers, pieces, courriels, tels, civils, cities, postals, reg.school.name ," ", teacher ,teacher_email, montant, " "," "," "," "," " ]

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
          headers = ["", "#", "Catégorie", "Participants", "Instruments",  "Durée", "Âge", "Compositeur", "Oeuvre"]
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
              pieces = ""
              composers = ""

              reg.performances.each do |perf|
                pieces += "#{perf.piece.title}" + "\n"
                composers += "#{perf.piece.composer.name}" + "\n"
              end

              reg.users.each do |u|
                participants += "#{u.name}" + "\n"
              end

              reg.instruments.order(:user_id).each do |i|
                instruments += "#{i.name}" + "\n"
              end

              sheet.row(irow).replace ['', reg.id, reg.category.name, participants, instruments, reg.duration,  reg.age_max, composers, pieces]
              irow+=1
            end
            sheet.row(irow).replace ['','','','','','Durée totale:', ts.duration ]
            irow+=2
          end
        end
      end
    end

    # Sauvegarder le fichier excel
    spreadsheet = StringIO.new
    excel_doc.write spreadsheet
    send_data spreadsheet.string, :filename => "FCMS-Inscriptions-#{Edition.find(Setting.find_by_key('current_edition_id').value).year}.xls", :type =>  "application/vnd.ms-excel"
  end
end
