class AutocompleteController < ApplicationController

  def cities
    @cities = City.all
    render :json => @cities.collect {|o| {:label => o.name, :value => o.id.to_s}}
  end

  def schools
    @schools = School.all
    render :json => @schools.collect {|o| {:label => o.name, :value => o.id.to_s}}
  end

  def composers
    search = params[:composer]

    if search
      search = search.upcase
      @composers = Composer.where("name LIKE '%#{search}%'")
    else
      @composers = Composer.all
    end

    render :json => @composers.collect {|o| {:label => o.name, :value => o.id.to_s}}
  end

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
    @users = User.all
    render :json => @users.collect {|o| {:label => o.first_name + ' ' + o.last_name, :value => o.id.to_s}}
  end

  def participants
    @participants = User.participants
    render :json => @participants.collect {|o| {:label => o.first_name + ' ' + o.last_name + ' (' + o.email + ')', :value => o.id.to_s}}
  end

end
