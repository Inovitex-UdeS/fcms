##
# Controller to respond to all the autocomplete calls from all the pages
class AutocompleteController < ApplicationController

  ##
  # Return all the cities
  def cities
    @cities = City.all
    render :json => @cities.collect {|o| {:label => o.name, :value => o.id.to_s}}
  end

  ##
  # Return all the schools
  def schools
    @schools = School.all
    render :json => @schools.collect {|o| {:label => o.name, :value => o.id.to_s}}
  end

  ##
  # Return all the composers corresponding to search
  def composers
    search = params[:query]

    if search
      search = search.upcase
      @composers = Composer.where("name LIKE '%#{search}%'")
    else
      @composers = Composer.all
    end

    render :json => @composers.collect {|o| {:label => o.name, :value => o.id.to_s}}
  end

  ##
  # Return all the pieces corresponding to search
  def pieces
    search = params[:q]
    composer = params[:c]

    if search && composer
      @pieces = Piece.where("composer_id = #{composer}").where("title LIKE '%#{search}%'")
    elsif search
      @pieces = Piece.where("name LIKE '%#{search}%'")
    else
      @pieces = Piece.all
    end

    render :json => @pieces.collect {|o| {:label => o.title, :value => o.id.to_s}}
  end

  def users
    search = params[:query]

    @users = User.where("(first_name LIKE '%#{search}%' OR last_name LIKE '%#{search}%' OR email LIKE '%#{search}%')")
    render :json => @users.collect {|o| {:label => o.first_name + ' ' + o.last_name, :value => o.id.to_s}}
  end

  ##
  # Return all the pieces corresponding to search and already used users
  def participants
    search = params[:query]
    userInReg = params[:noUser]

    if search
      query = "(first_name LIKE '%#{search}%' OR last_name LIKE '%#{search}%' OR email LIKE '%#{search}%')"

      if userInReg
        query += "AND users.id NOT IN("
        userInReg.each do |user_id|
            query += (user_id.to_s + ",")
        end
        query.chop!
        query += ")"
      end

      @participants = User.participants.where(query)
    else
      @participants = User.participants
    end

    render :json => @participants.collect {|o| {:label => o.first_name + ' ' + o.last_name + ' (' + o.email + ')', :value => o.id.to_s}}
  end

  ##
  # Return all the teachers
  def teachers
    search = params[:query]

    @teachers = User.teachers.where("(first_name LIKE '%#{search}%' OR last_name LIKE '%#{search}%' OR email LIKE '%#{search}%')")
    render :json => @teachers.collect {|o| {:label => o.first_name + ' ' + o.last_name + ' (' + o.email + ')', :value => o.id.to_s}}
  end

  ##
  # Return all the accompanists
  def accompanists
    search = params[:query]

    @accompanist = User.accompanists.where("(first_name LIKE '%#{search}%' OR last_name LIKE '%#{search}%' OR email LIKE '%#{search}%')")
    render :json => @accompanist.collect {|o| {:label => o.first_name + ' ' + o.last_name + ' (' + o.email + ')', :value => o.id.to_s}}
  end
end
