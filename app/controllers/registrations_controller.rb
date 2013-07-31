#encoding: utf-8
##
# Registration controller for all the registrations made by participants
class RegistrationsController < ApplicationController

  ##
  # Prevent the unconfirmed judges to access to the full list of all the registrations
  before_filter :prevent_unconfirmed_judge, :only => :index

  ##
  # Prevent non-participants to create a registration
  before_filter :prevent_non_participant, :only => :create

  ##
  # Populate registrations grid
  # If participant -> Add registrations involved in
  # If teacher -> + Add registrations you are the teacher
  # If accompanist -> + Add registrations you are the accompanist
  # If judge -> See all the registrations of the current edition
  def index
    @current_edition = Setting.find_by_key('current_edition_id').value
    @registrations = []

    if current_user.is_participant?
      @registrations += current_user.registrations.where("edition_id=#{@current_edition}")
    end

    if current_user.is_teacher?
      @registrations += Registration.where(edition_id:@current_edition, :user_teacher_id =>  current_user.id )
    end

    if current_user.is_accompanist?
      @registrations += Registration.where(edition_id: @current_edition, :user_accompanist_id => current_user.id)
    end

    if current_user.is_judge?
      @registrations = Registration.where(edition_id:@current_edition)
    end
  end

  ##
  # View to create new registration
  def new
    @registration = Registration.new
    @owner_id = current_user.id
    @user_school = User.find(@owner_id).school_id
    @current_edition = Setting.find_by_key('current_edition_id').value
    @teachers = User.teachers
    @accompanists = User.accompanists
    @participants = User.participants
    @user = User.new
    @composer = Composer.new
  end

  ##
  # Manually create the registration
  # Will need to delete the associations created by Rails since we don't respect the standard way to do it.
  # After, we need to create them manually
  # Don't forget to create RegistrationUser for owner
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

  ##
  # Edit page for the registrations
  def edit
    @registration = Registration.find(params[:id])

    if not @registration
      render :json => { :message => "L'enregistrement n'a pas été trouvé" }, :status => :unprocessable_entity
    end

    if @registration.user_owner_id  != current_user.id
      redirect_to root_path, :alert => "Vous n'êtes pas autorisé à consulter les inscriptions des autres"
    end
    @teachers = User.teachers
    @accompanists = User.accompanists
    @participants = User.participants
    @user_school = @registration.owner.school_id
    @current_edition = @registration.edition_id
    @user = User.new
    @composer = Composer.new
  end

  ##
  # Handle update request for registrations
  # Like create, we need to do a lot of manual work in order to update it properly
  def update
    begin
      @registration = Registration.find(params[:id])

      if not @registration
        render :json => { :message => "L'enregistrement n'a pas été trouvé" }, :status => :unprocessable_entity
      end

      if current_user.id != @registration.user_owner_id
        render :json => { :message => "Vous n'êtes pas le propriétaire de l'enregistrement" }, :status => :unprocessable_entity
      end

      # Manually update registration
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

          if not perf[1][:piece_attributes]
              next
          end

          composer_id = perf[1][:piece_attributes][:composer_id]
          piece_title = perf[1][:piece_attributes][:title]

          piece = Piece.where("composer_id=#{composer_id} AND title='#{piece_title}'").first
          piece ||= Piece.create(title: piece_title, composer_id: composer_id)

          Performance.create(registration_id: @registration.id, piece_id: piece.id)
        end
      end

      RegistrationsUser.delete_all("registration_id = #{@registration.id}")

      # Create registrations_user for the current user
      RegistrationsUser.create(user_id: current_user.id, instrument_id:  params[:registration][:instrument_ids], registration_id: @registration.id)

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

      redirect_to  registrations_path, :notice => 'La modification de l\'inscription a été complétée avec succès'
    rescue => e
      redirect_to  registrations_path, :alert => 'La modification de l\'inscription n\'a pas été complétée avec succès'
    end
  end

  ##
  # Get method to delete registrations, it's suppose to be a delete method, but since it's a href, we didn't spend time to hack around
  # Redirect to registration page
  def cancel
    begin
      @registration = Registration.find(params[:id])

      if not @registration
        render :json => { :message => "L'enregistrement n'a pas été trouvé" }, :status => :unprocessable_entity
      end

      if current_user.id != @registration.user_owner_id
        render :json => { :message => "Vous n'êtes pas le propriétaire de l'enregistrement" }, :status => :unprocessable_entity
      end

      RegistrationsUser.delete_all("registration_id = #{@registration.id}")
      Performance.delete_all("registration_id = #{@registration.id}")

      @registration.delete

      redirect_to registrations_path, :notice => "L'inscription a été supprimée avec succès!"
    rescue => e
      redirect_to registrations_path, :alert => "L'inscription n'a pas été supprimée..."
    end
  end

  ##
  # JSON request to return registration
  def show
    @registration = Registration.find(params[:id])
    @users = RegistrationsUser.joins(:user).where("registrations_users.registration_id =#{@registration.id} AND NOT registrations_users.user_id = #{@registration.user_owner_id}")
    render :json => {:registration =>@registration.to_json(:include => {:performances => {:include => {:piece => {:include => {:composer => {}}}}}}), :users => @users.to_json(:include => {:user => {}}) }
  end

end
