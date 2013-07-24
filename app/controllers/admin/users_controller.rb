#encoding: utf-8
class Admin::UsersController < ApplicationController
  before_filter :prevent_non_admin

  def new
    @users  = User.all
    @user = User.new
    @user.contactinfo ||= Contactinfo.new
    @user.contactinfo.city ||= City.new
  end

  def update
    begin
      @user = User.find(params[:id])

      if @user.update_attributes(params[:user])
        render json: @user, status: :ok
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    rescue
      render :json => {:message => "Erreur lors de la mise à jour de l'utilisateur"}, :status => :unprocessable_entity
    end
  end

  def destroy
    begin
      @user = User.find(params[:id])

      @user.roles.each do |role|
        @user.roles.delete(role)
      end

      @user.registrations.each do |registration|
        RegistrationsUser.find_all_by_registration_id(registration.id).each do |regUser|
          RegistrationsUser.delete(regUser)
        end

        Performance.find_all_by_registration_id(registration.id).each do |performance|
          Performance.delete(performance)
        end

        Payment.find_all_by_registration_id(registration.id).each do |payment|
          Payment.delete(payment)
        end

        Registration.delete(registration)
      end

      Registration.find_all_by_user_owner_id(@user.id).each do |registration|
        RegistrationsUser.find_all_by_registration_id(registration.id).each do |regUser|
          RegistrationsUser.delete(regUser)
        end

        Performance.find_all_by_registration_id(registration.id).each do |performance|
          Performance.delete(performance)
        end

        Payment.find_all_by_registration_id(registration.id).each do |payment|
          Payment.delete(payment)
        end

        Registration.delete(registration)
      end

      Registration.find_all_by_user_teacher_id(@user.id).each do |registration|
        RegistrationsUser.find_all_by_registration_id(registration.id).each do |regUser|
          RegistrationsUser.delete(regUser)
        end

        Performance.find_all_by_registration_id(registration.id).each do |performance|
          Performance.delete(performance)
        end

        Payment.find_all_by_registration_id(registration.id).each do |payment|
          Payment.delete(payment)
        end

        Registration.delete(registration)
      end

      @user.delete
      render :json => {:message => "L'utilisateur a bien été supprimé!"}, :status => :unprocessable_entity
    rescue => e
      render :json => {:message => e.message }, :status => :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
    render :json => @user.to_json(:include => {:contactinfo => {:include => :city}})
  end


  def ProduceExcel
    require 'spreadsheet'
    excel_doc = Spreadsheet::Workbook.new

    header_format = Spreadsheet::Format.new :weight => :bold, :size => 12

    sheet_user = excel_doc.create_worksheet  :name =>  "USERS"
    headers = ["Nom", "Prénom", "Âge", "Rôle(s)", "Nombre d'inscriptions", "Courriel","#Tel",
               "Rue","Ville", "Code postal",]
    sheet_user.row(0).replace headers
    sheet_user.column(0).width = 20
    headers.each_index do |i|
      sheet_user.column(i).width = headers.at(i).to_s.length+3
    end
    sheet_user.row(0).default_format = header_format

    i = 1
    User.all.each do |u|
      roles = ""
      u.roles.each do |role|
        roles += "#{role.name} \n"
      end

      if c = u.contactinfo
        tel = c.telephone
        rue = c.address
        ville = c.city.name
        post = c.postal_code
      else
        tel   = ""
        rue   = ""
        ville = ""
        post  = ""
      end
      regcount = u.registrations.where(edition_id: Setting.find_by_key('current_edition_id')).size
      sheet_user.row(i).replace [u.last_name, u.first_name, u.age , roles, regcount, u.email, tel,rue, ville, post]
      i += 1
    end

    # Sauvegarder le fichier excel
    spreadsheet = StringIO.new
    excel_doc.write spreadsheet
    send_data spreadsheet.string, :filename => "FCMS-Utilisateurs-#{Edition.find(Setting.find_by_key('current_edition_id').value).year}.xls", :type =>  "application/vnd.ms-excel"
  end
end
