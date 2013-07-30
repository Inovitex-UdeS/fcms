#encoding: utf-8

##
# Controller to manipulate agegroups bound to a category
class Admin::AgegroupsController < ApplicationController
  before_filter :prevent_non_admin

  ##
  # Page to see all the current agegroups
  def new
    @agegroups = Agegroup.all
    @agegroup = Agegroup.new
  end

  ##
  # Handle update request
  def update
    begin
      @agegroup = Agegroup.find(params[:id])
      if @agegroup
        if @agegroup.update_attributes(ActiveSupport::JSON.decode(params[:agegroup]))
          render :json => @agegroup
        else
          render :json => {:message => "Le groupe d'âge n'a pu être mis à jour"}, :status => :unprocessable_entity
        end
      else
        render :json => {:message => "Le groupe d'âge n'a pas été trouvé"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Erreur lors de la mise à jour du groupe d'âge"}, :status => :unprocessable_entity
    end
  end

  ##
  # Handle create request for agegroup.
  def create
    begin
      #We needed to user JSON.decode since the form was weirdly build we couldn't user $('form').serialize() directly
      @agegroup = Agegroup.new(ActiveSupport::JSON.decode(params[:agegroup]))

      if @agegroup.save
        render :json => @agegroup
      else
        render :json => {:message => @agegroup.errors.full_messages}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => @agegroup.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  ##
  # Destroy an agegroup, will fail if agegroup has links to categories
  def destroy
    begin
      agegroup = Agegroup.find(params[:id])
      if agegroup
        agegroup.destroy
        render :json => {:message => "Le groupe d'âge a été supprimé avec succès"}, :status => :ok
      else
        render :json => {:message =>  "Le groupe d'âge n'a pas été trouvé"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Le groupe d'âge est lié à d'autres objets dans la base de données (categories, inscriptions, ...). Veuillez les supprimer en premier."}, :status => :unprocessable_entity
    end
  end
end