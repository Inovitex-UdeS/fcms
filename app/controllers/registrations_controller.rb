#encoding: utf-8
class RegistrationsController < ApplicationController
  before_filter :prevent_unconfirmed_judge, :only => :index
  before_filter :prevent_non_participant, :only => :create

  def index
    @current_edition = Setting.find_by_key('current_edition_id').value
    @registrations = []

    if current_user.is_participant?
      @registrations += current_user.registrations.where("edition_id=#{@current_edition}")
    end

    if current_user.is_teacher?
      @registrations += Registration.where("edition_id=#{@current_edition} AND user_teacher_id=#{current_user.id}")
    end

    if current_user.is_judge?
      @registrations = Registration.where("edition_id=#{@current_edition}")
    end

  end

  def new
    @registration = Registration.new
    @owner_id = current_user.id
    @current_edition = Setting.find_by_key('current_edition_id').value
    @teachers = User.teachers
    @participants = User.participants
    @user = User.new
    @composer = Composer.new
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
      if @registration.association_cache[:performances]
        @registration.association_cache.delete(:performances)
      end

      if !@registration.save
        render :json => { :message => @registration.errors.full_messages }, :status => :unprocessable_entity
      end

      # Manually create performances
      if association_cache[:performances]
        association_cache[:performances].target.each do |perf|
          composer_id = perf.association_cache[:piece].target.attributes['composer_id']
          piece_title = perf.association_cache[:piece].target.attributes['title']

          piece = Piece.where("composer_id=#{composer_id} AND title='#{piece_title}'").first
          piece ||= Piece.create(title: piece_title, composer_id: composer_id)

          Performance.create(registration_id: @registration.id, piece_id: piece.id)
        end
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

      # Update age max
      age_max = 0;
      @registration.users.each do |user|
        age_max = user.age if user.age > age_max
      end
      @registration.update_attribute(:age_max, age_max)

      render :json => {:registration => @registration, :message => 'L\'inscription a été crée avec succès'}
    rescue => e
      render :json => { :message => e.message }, :status => :unprocessable_entity
    end
  end
end
