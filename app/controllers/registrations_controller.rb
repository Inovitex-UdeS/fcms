#encoding: utf-8
class RegistrationsController < ApplicationController
  def index
    @registrations = current_user.registrations
  end

  def new
    @registration = Registration.new
    @owner_id = current_user.id
    @current_edition = Setting.find_by_key('current_edition_id').value
    @teachers = User.teachers
    @participants = User.participants
    @user = User.new
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
      RegistrationsUser.create(user_id: current_user.id, instrument_id: association_cache[:instruments].target[0].id, registration_id: @registration.id)

      # Create remaining registration_users
      if association_cache[:registrations_users]
        association_cache[:registrations_users].target.each do |reg|
          reg.registration_id = @registration.id
          reg.changed_attributes[:registration_id] = nil
          reg.save
        end
      end

      render :json => {:registration => @registration, :message => 'L\'inscription a été crée avec succès'}
    rescue => e
      render :json => { :message => e.message }, :status => :unprocessable_entity
    end
  end

end
