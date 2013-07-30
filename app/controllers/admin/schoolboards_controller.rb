#encoding: utf-8

##
# Controller to manipulate schoolboards in the application
class Admin::SchoolboardsController < ApplicationController
  before_filter :prevent_non_admin

  ##
  # Get the page to display all the schoolboards
  def new
    @schoolboard = Schoolboard.new
    @schoolboards = Schoolboard.all
  end

  ##
  # Create a schoolboard, that will later be linked to a school
  def create
    begin
      @schoolboard = Schoolboard.new(params[:schoolboard])
      if @schoolboard.save
        render :json => @schoolboard
      else
        render :json => {:message => @schoolboard.errors.full_messages}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => @schoolboard.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  ##
  # Delete the schoolboard, will fail if it is linked to a school
  def destroy
    begin
      @schoolboard = Schoolboard.find(params[:id])
      if @schoolboard
        @schoolboard.destroy
        render :json => {:message => "La commission scolaire a été supprimée avec succès"}, :status => :ok
      else
        render :json => {:message => "La commission scolaire n'a pas été trouvée"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "La commission scolaire est liée à d'autres objets dans la base de données (écoles). Veuillez les supprimer en premier."}, :status => :unprocessable_entity
    end
  end

  ##
  # Update name of schoolboard
  def update
    begin
      @schoolboard = Schoolboard.find(params[:id])
      if @schoolboard
        if @schoolboard.update_attributes(params[:schoolboard])
          render :json => @schoolboard
        else
          render :json =>{:message => "La commission scolaire n'a pu être mise à jour"}, :status => :unprocessable_entity
        end
      else
        render :json => {:message =>  "La commission scolaire n'a pas été trouvée"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Erreur lors de la mise à jour de la commission scolaire"}, :status => :unprocessable_entity
    end
  end

  ##
  # JSON request to return basic information about schoolboard
  def show
    @schoolboard = Schoolboard.find(params[:id])
    render :json => @schoolboard
  end
end
