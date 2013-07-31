#encoding: utf-8

##
# Admin controller to creat, edit or delete registrations
class Admin::RegistrationsController < ApplicationController
  before_filter :prevent_non_admin

  ##
  # Handle JSON request for ajax dataTables
  def index
    render json: RegistrationsDatatable.new(view_context)
  end

  ##
  # Display the page for all the registrations in the application (all editions included)
  def new
    @user = User.new
    @user_school_id =
    @registrations = Registration.all
    @registration = Registration.new
    @current_edition = Setting.find_by_key('current_edition_id').value
    @teachers = User.teachers
    @participants = User.participants
    @accompanists = User.accompanists
  end

  ##
  # Create new registration
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
        return
      end

      # Manually create performances
      if params[:registration][:performances_attributes]
        params[:registration][:performances_attributes].each do |perf|
          composer_id = perf[1][:piece_attributes][:composer_id]
          piece_title = perf[1][:piece_attributes][:title]

          piece = Piece.where("composer_id=#{composer_id} AND title='#{piece_title}'").first
          piece ||= Piece.create(title: piece_title, composer_id: composer_id)

          Performance.create(registration_id: @registration.id, piece_id: piece.id)
        end
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

      # Update age max
      age_max = 0;
      @registration.users.each do |user|
        age_max = user.age if user.age > age_max
      end
      @registration.update_attribute(:age_max, age_max)

      # Format string for dataTables
      users_string = '<b>' + @registration.owner.last_name + ', ' + @registration.owner.first_name + '</b><br>'

      @registration.users.where("users.id != #{@registration.user_owner_id}").each do |user|
        users_string += user.last_name + ', ' +  user.first_name  + '<br>'
      end
      if !users_string.empty?
        users_string.chomp!('<br>')
      end

      instruments_string = ''
      @registration.instruments.each do |inst|
        instruments_string += inst.name + '<br>'
      end
      if !instruments_string.empty?
        instruments_string.chomp!('<br>')
      end

      pieces_string = ''
      @registration.pieces.each do |piece|
        pieces_string += piece.title + '<br>'
      end
      if !pieces_string.empty?
        pieces_string.chomp!('<br>')
      end

      composers_string = ''
      @registration.composers.each do |compo|
        composers_string += compo.name + '<br>'
      end
      if !composers_string.empty?
        composers_string.chomp!('<br>')
      end

      render :json => {:registration => @registration.to_json,
                       :category => @registration.category.name.to_s,
                       :users => users_string,
                       :instruments => instruments_string,
                       :pieces => pieces_string,
                       :composers => composers_string,
                       :edition => @registration.edition.year.to_s,
                       :teacher => @registration.teacher.to_json,
                       :message => 'L\'inscription a été modifiée avec succès'}
    rescue => e
      render :json => { :message => e.message }, :status => :unprocessable_entity
    end
  end

  ##
  # JSON request to return basic information about the registration
  def show
    @registration = Registration.find(params[:id])
    @users = RegistrationsUser.where("registrations_users.registration_id =#{@registration.id} AND NOT registrations_users.user_id = #{@registration.user_owner_id}")
    @owner = @registration.owner
    @teacher = @registration.teacher
    @accompanist = @registration.accompanist
    @instrument = RegistrationsUser.where("registrations_users.registration_id =#{@registration.id} AND registrations_users.user_id = #{@registration.user_owner_id}").first.instrument
    render :json => {:registration => @registration.to_json(:include => {:performances => {:include => {:piece => {:include => {:composer => {}}}}}}), :users => @users.to_json(:include => {:user => {}}), :owner => @owner.to_json, :teacher => @teacher.to_json, :accompanist => @accompanist.to_json,  :instrument => @instrument.to_json }
  end

  ##
  # Update
  def update
    begin
      @registration = Registration.find(params[:id])

      if not @registration
        render :json => { :message => "L'enregistrement n'a pas été trouvé" }, :status => :unprocessable_entity
      end

      # Manually update registration
      @registration.user_owner_id = params[:registration][:user_owner_id]
      @registration.user_teacher_id = params[:registration][:user_teacher_id]
      @registration.duration = params[:registration][:duration].to_f.ceil
      @registration.category_id = params[:registration][:category_id]

      if !@registration.save
        render :json => { :message => @registration.errors.full_messages }, :status => :unprocessable_entity
      end

      @registration.performances.delete_all

      # Manually create performances
      if params[:registration][:performances_attributes]
        params[:registration][:performances_attributes].each do |perf|
          composer_id = perf[1][:piece_attributes][:composer_id]
          piece_title = perf[1][:piece_attributes][:title]

          piece = Piece.where("composer_id=#{composer_id} AND title='#{piece_title}'").first
          piece ||= Piece.create(title: piece_title, composer_id: composer_id)

          Performance.create(registration_id: @registration.id, piece_id: piece.id)
        end
      end

      RegistrationsUser.delete_all("registration_id = #{@registration.id}")

      # Create registrations_user for the current user
      RegistrationsUser.create(user_id: @registration.user_owner_id, instrument_id:  params[:registration][:instrument_ids], registration_id: @registration.id)

      # Create remaining registration_users
      if params[:registration][:registrations_users_attributes]
        params[:registration][:registrations_users_attributes].each do |user|
          RegistrationsUser.create(user_id: user[1][:user_id], instrument_id:  user[1][:instrument_id], registration_id: @registration.id)
        end
      end

      # Update age max
      age_max = 0;
      @registration.users.each do |user|
        age_max = user.age if user.age > age_max
      end
      @registration.update_attribute(:age_max, age_max)

      # Format string for dataTables
      users_string = '<b>' + @registration.owner.last_name + ', ' + @registration.owner.first_name + '</b><br>'

      @registration.users.where("users.id != #{@registration.user_owner_id}").each do |user|
        users_string += user.last_name + ', ' +  user.first_name  + '<br>'
      end
      users_string.chomp!('<br>')

      instruments_string = ''
      @registration.instruments.each do |inst|
        instruments_string += inst.name + '<br>'
      end
      instruments_string.chomp!('<br>')

      pieces_string = ''
      @registration.pieces.each do |piece|
        pieces_string += piece.title + '<br>'
      end
      pieces_string.chomp!('<br>')

      composers_string = ''
      @registration.composers.each do |compo|
        composers_string += compo.name + '<br>'
      end
      composers_string.chomp!('<br>')

      render :json => {:registration => @registration.to_json,
                       :category => @registration.category.name.to_s,
                       :users => users_string,
                       :instruments => instruments_string,
                       :pieces => pieces_string,
                       :composers => composers_string,
                       :edition => @registration.edition.year.to_s,
                       :teacher => @registration.teacher.to_json,
                       :message => 'L\'inscription a été modifiée avec succès'}
    rescue => e
      render :json => { :message => e.message }, :status => :unprocessable_entity
    end
  end

  ##
  # Delete a registrations, all performances and all rows in registrations_users table
  def destroy
    begin
      @registration = Registration.find(params[:id])

      if not @registration
        render :json => { :message => "L'enregistrement n'a pas été trouvé" }, :status => :unprocessable_entity
      end

      RegistrationsUser.delete_all("registration_id = #{@registration.id}")
      Performance.delete_all("registration_id = #{@registration.id}")

      @registration.delete

      render :json => {:registration => @registration, :message => 'L\'inscription a été supprimée avec succès'}
    rescue => e
      render :json => { :message => e.message }, :status => :unprocessable_entity
    end
  end

end
