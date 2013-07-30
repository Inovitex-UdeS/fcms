#encoding: utf-8

##
# Controller to manipulate editions in the application
class Admin::EditionsController < ApplicationController
  before_filter :prevent_non_admin

  ##
  # Get the page to display all editions
  def new
    @edition = Edition.new
    @editions = Edition.all
    @current_edition = Setting.find_by_key('current_edition_id').value
  end

  ##
  # Controller to manipulate editions in the application
  def create
    begin
      @edition = Edition.new(params[:edition])
      if @edition.save
        render :json => @edition
      else
        render :json => {:message => @edition.errors.full_messages}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => @edition.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  ##
  # Delete the edition, will fail if the edition is linked to a registration
  def destroy
    begin
      @edition = Edition.find(params[:id])
      if @edition
        @edition.destroy
        render :json => {:message => "L'édition a été supprimé avec succès"}, :status => :ok
      else
        render :json => {:message => "L'édition n'a pas été trouvé"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "L'édition est liée à d'autres objets dans la base de données (inscriptions, catégories, ...). Veuillez les supprimer en premier."}, :status => :unprocessable_entity
    end
  end

  ##
  # Update information about the edition
  def update
    begin
      @edition = Edition.find(params[:id])
      if @edition
        if @edition.update_attributes(params[:edition])
          render :json => @edition
        else
          render :json =>{:message => "L'édition n'a pu être mis à jour"}, :status => :unprocessable_entity
        end
      else
        render :json => {:message =>  "L'édition n'a pas été trouvé"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Erreur lors de la mise à jour de l'édition"}, :status => :unprocessable_entity
    end
  end

  ##
  # JSON request to return basic information about the edition
  def show
    @edition = Edition.find(params[:id])
    render :json => @edition
  end

end
