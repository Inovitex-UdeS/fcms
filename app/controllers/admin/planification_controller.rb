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
    require 'axlsx'
    Axlsx::Package.new do |p|
      p.workbook.styles do |s|
        header_format = s.add_style :sz => 12, :b => true, :alignment => {  :wrap_text => true}
        string_cell = s.add_style :sz => 12, :alignment => {  :wrap_text => true}

        # Main tab
        p.workbook.add_worksheet(:name => "TOUT") do |sheet|

          sheet.add_row ["#", "Catégorie", "Bloc associé", "Participants", "Instrument",  "Durée", "Compositeur", "Oeuvre", "Courriel", "#Tel",
                         "Rue","Ville", "Code postal", "Institution scolaire","École musique",  "Professeur","Courriel Prof", "Montant à payer", "Payé","#chq","Date Paiment",  "Résultat", "Note" ], :style => header_format


          Registration.order(:category_id).each do |reg|
            montant = 0
            if (group = Agegroup.where(edition_id: Setting.find_by_key('current_edition_id').value , :category_id=> reg.category).where("#{reg.age_max} BETWEEN min and max").first)
              montant = group.fee * reg.users.count
            end

            tslot = reg.timeslot ? reg.timeslot.label : ''
            teacher = reg.teacher ? reg.teacher.name : ''
            teacher_email = reg.teacher ? reg.teacher.email : ''

            participants = reg.users.map  {|u| u.name}.join("\r\n")
            courriels = reg.users.map     {|u| u.email}.join("\r\n")
            tels = reg.users.map          {|u| u.contactinfo.telephone}.join("\r\n")
            civils = reg.users.map        {|u| u.contactinfo.address}.join("\r\n")
            cities = reg.users.map        {|u| u.contactinfo.city.name}.join("\r\n")
            postals = reg.users.map       {|u| u.contactinfo.postal_code}.join("\r\n")
            instruments = reg.instruments.order(:user_id).map {|i| i.name}.join("\r\n")
            composers = reg.performances.order(:id).map {|p| p.piece.composer.name}.join("\r\n")
            pieces = reg.performances.order(:id).map {|p| p.piece.title}.join("\r\n")

            sheet.add_row   [reg.id, reg.category.name, tslot, participants, instruments,  reg.duration, composers, pieces, courriels, tels, civils, cities, postals, reg.school.name ," ", teacher ,teacher_email, montant, " "," "," "," "," " ], :style => string_cell

            end
          sheet.to_xml_string
        end

        # Other tabs
        Category.order(:name).each do |cat|
          unless cat.timeslots.empty?
            headers = [nil, "#", "Catégorie", "Participants", "Instruments",  "Durée", "Âge", "Compositeur", "Oeuvre"]
            p.workbook.add_worksheet(:name => cat.name.truncate(12)) do |sheet|
              cat.timeslots.each do |ts|
                sheet.add_row [ts.label], :style => header_format
                sheet.add_row headers, :style => header_format


                ts.registrations.each do |reg|

                  pieces = reg.performances.map {|p| p.piece.title}.join("\r\n")
                  composers = reg.performances.map {|p| p.piece.composer.name}.join("\r\n")
                  participants = reg.users.map {|u| u.name}.join("\r\n")
                  instruments = reg.instruments.order(:user_id).map {|i| i.name}.join("\r\n")

                  sheet.add_row [nil, reg.id, reg.category.name, participants, instruments, reg.duration,  reg.age_max, composers, pieces], :style => string_cell
                end
                sheet.add_row [nil,nil,nil,nil,nil,'Durée totale:', ts.duration ]
                sheet.add_row [""]
              end
              sheet.to_xml_string
            end
          end
        end
      end

      p.use_shared_strings = true     # THAT'S FOR LINE RETURNS FORMATTING...

      # This writes the file locally. I don't think we need it on the server
      #p.serialize("FCMS-Inscriptions-#{Edition.find(Setting.find_by_key('current_edition_id').value).year}.xlsx")
      send_data p.to_stream.read, :filename => "FCMS-Inscriptions-#{Edition.find(Setting.find_by_key('current_edition_id').value).year}.xlsx", :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"
    end

  end
end
