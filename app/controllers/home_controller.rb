class HomeController < ApplicationController

  def index

    # Will call index view by default
  end

  def ProduceExcel
    # Beau guide : http://spreadsheet.rubyforge.org/files/GUIDE_txt.html
    require 'spreadsheet'

    # Créer le book!
    excel_doc = Spreadsheet::Workbook.new

    # On crée un TAB Excel avec un nom :)
    sheet_All = excel_doc.create_worksheet  :name => "Participants"

    # On set les colonnes du workbook
    sheet_All.row(0).concat %w{Nom Ville CodePostal}

    # On prends des infos de user pour des tests
    it = 1
    User.all.each do |usr|
      sheet_All.row(it).replace [usr.first_name + " " + usr.last_name, usr.contactinfo.city.name, usr.contactinfo.postal_code ]
      it = it + 1
    end

    #Un exemple de styling... for the style!
    sheet_All.row(0).height = 18

    format = Spreadsheet::Format.new :color => :blue,
                                     :weight => :bold,
                                     :size => 12
    sheet_All.row(0).default_format = format

    # On se crée un StringIO pour exporter l'excel en download
    spreadsheet = StringIO.new
    excel_doc.write spreadsheet

    # On envoie le excel résultant
    send_data spreadsheet.string, :filename => "Liste_User.xls", :type =>  "application/vnd.ms-excel"
  end

end
