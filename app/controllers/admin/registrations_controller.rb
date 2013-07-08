#encoding: utf-8
class Admin::RegistrationsController < ApplicationController
  before_filter :prevent_non_admin

  def new
    @user = User.new
    @registrations = Registration.all
    @registration = Registration.new
    @current_edition = Setting.find_by_key('current_edition_id').value
    @teachers = User.teachers
    @participants = User.participants
  end

  def create
    begin
      @registration = Registration.new(params[:registration])

      # Round duration to top
      @registration.duration = @registration.duration.ceil

      # Clear association cache because we need to manually create it
      association_cache = @registration.association_cache.clone
      if @registration.association_cache[:instruments]
        @registration.association_cache.delete(:instruments)
      end
      if @registration.association_cache[:registrations_users]
        @registration.association_cache.delete(:registrations_users)
      end

      if !@registration.save
        render :json => { :message => @registration.errors.full_messages }, :status => :unprocessable_entity
      end

      # Create registrations_user for the current user
      RegistrationsUser.create(user_id: params[:registration][:user_owner_id], instrument_id: association_cache[:instruments].target[0].id, registration_id: @registration.id)

      # Create remaining registration_users
      if association_cache[:registrations_users]
        association_cache[:registrations_users].target.each do |reg|
          reg.registration_id = @registration.id
          reg.changed_attributes[:registration_id] = nil
          reg.save
        end
      end
      redirect_to new_admin_registration_path, notice: "L'inscription a été créée avec succès!"
    rescue => e
      redirect_to new_admin_registration_path, alert: e.messages
    end
  end

end
