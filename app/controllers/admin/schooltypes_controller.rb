#encoding: utf-8

##
# Controller to manipulate cities in the application
class Admin::SchooltypesController < ApplicationController
  before_filter :prevent_non_admin

  ##
  # Get the page to display all the current school types in the application
  def new
    @schooltype = Schooltype.new
    @schooltypes = Schooltype.all
  end

  ##
  # Create a schooltype that will later be linked to a school
  def create
    begin
      @schooltype = Schooltype.new(params[:schooltype])
      if @schooltype.save
        render :json => @schooltype
      else
        render :json => {:message => @schooltype.errors.full_messages}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => @schooltype.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  ##
  # Delete a schooltype, will fail if it is already linked to a school
  def destroy
    begin
      @schooltype = Schooltype.find(params[:id])
      if @schooltype
        @schooltype.destroy
        render :json => {:message => "Le type d'école a été supprimé avec succès"}, :status => :ok
      else
        render :json => {:message => "Le type d'école n'a pas été trouvé"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Le type d'école est lié à d'autres objets dans la base de données (écoles). Veuillez les supprimer en premier."}, :status => :unprocessable_entity
    end
  end

  ##
  # Update the name of the schooltype
  def update
    begin
      @schooltype = Schooltype.find(params[:id])
      if @schooltype
        if @schooltype.update_attributes(params[:schooltype])
          render :json => @schooltype
        else
          render :json =>{:message => "Le type d'école n'a pu être mis à jour"}, :status => :unprocessable_entity
        end
      else
        render :json => {:message =>  "La type d'école n'a pas été trouvé"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Erreur lors de la mise à jour du type d'école"}, :status => :unprocessable_entity
    end
  end

  ##
  # JSON request to return basic information about the schooltype
  def show
    @schooltype = Schooltype.find(params[:id])
    render :json => @schooltype
  end

end
