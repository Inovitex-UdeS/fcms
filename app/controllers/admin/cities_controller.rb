#encoding: utf-8

##
# Controller to manipulate cities in the application
class Admin::CitiesController < ApplicationController
  before_filter :prevent_non_admin

  ##
  # Show the page of all cities in the application
  def new
    @city = City.new
    @cities = City.all
  end

  ##
  # Handle create request for new cities
  def create
    begin
      @city = City.new(params[:city])
      if @city.save
        render :json => @city
      else
        render :json => {:message => @city.errors.full_messages}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => @city.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  ##
  # Delete a city, will fail if it is already linked to contactinfo of users or schools
  def destroy
    begin
      @city = City.find(params[:id])
      if @city
        @city.destroy
        render :json => {:message => "La ville a été supprimée avec succès"}
      else
        render :json => {:message => "La ville n'a pas été trouvée"}, :status => :unprocessable_entity
      end
    rescue => e
      render :json => {:message => "La ville est liée à d'autres objets dans la base de données (utilisateurs, écoles, ...). Veuillez les supprimer en premier." }, :status => :unprocessable_entity
    end
  end

  ##
  # Update information of the city (name)
  def update
    begin
      @city = City.find(params[:id])
      if @city
        if @city.update_attributes(params[:city])
          render :json => @city
        else
          render :json =>{:message => "La ville n'a pu être mise à jour"}, :status => :unprocessable_entity
        end
      else
        render :json => {:message =>  "La ville n'a pas été trouvée"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Erreur lors de la mise à jour de la ville"}, :status => :unprocessable_entity
    end
  end

  ##
  # JSON request to return basic information about the city
  def show
    @city = City.find(params[:id])
    render :json => @city
  end
end
