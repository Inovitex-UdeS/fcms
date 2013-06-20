#encoding: utf-8

class RegistrationsController < ApplicationController
  def index
    @registration  = Registration.new
    @registrations = Registration.all
  end

  def new
    @registration = Registration.new
  end

  def create
    begin
      edition_id = 1
      if current_user.has_role?('Administrateur')
        owner_first_name = params[:registration][:user_owner_id].split.first
        owner_last_name  = params[:registration][:user_owner_id].split.last
        owner_id = User.where(first_name: owner_first_name, last_name: owner_last_name).first.id

      else
        owner_id = current_user.id
    end
      school_id = params[:registration][:school_id]
      teacher_id = params[:registration][:user_teacher_id]#User.find_by_email(params[:registration][:user_teacher_id]).id
      duration =  params[:duration]
      instrument_id = params[:registration][:instrument_ids]
      category_id = params[:registration][:category_id]

      # We need to create the registration first or we will not be able to bind to it
      @registration = Registration.create(user_owner_id: owner_id, school_id: school_id, user_teacher_id: teacher_id,
                                          edition_id: edition_id, category_id: category_id, duration: duration)

      performances = params[:registration][:performances_attributes]

      # Create all related performances
      performances.each do |performance|
        performance = performance[1]
        composer = Composer.find_or_create_by_name(performance[:piece][:composer][:name])
        piece = Piece.find_by_title(performance[:piece][:title])
        if not piece
          piece = Piece.create(title:performance[:piece][:title], composer: composer)
        end
        Performance.create(piece_id: piece.id, registration_id: @registration.id)
      end

      users = params[:registration][:users_attributes]

      # Create user registration for the one creating the registration
      RegistrationsUser.create(user_id: owner_id, registration_id: @registration.id, instrument_id: instrument_id)

      # Create the others
      if users
        users.each do |user|
          user = user[1]
          RegistrationsUser.create(user_id: User.find_by_email(user[:email]).id, registration_id: registration_id, instrument_id: user[:instrument_ids])
        end
      end

      if @registration.save
        render :json => @registration
      else
        render :json => { :errors => @registration.errors.full_messages }, :status => 422
      end

    rescue
        render :json => { :errors => "Erreur" }, :status => 422
    end
  end

end
