#encoding: utf-8
class Admin::UsersController < ApplicationController

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

end
