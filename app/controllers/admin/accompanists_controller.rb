#encoding: utf-8

##
# Admin controller to give or remove accompanist role to a user
class Admin::AccompanistsController < ApplicationController
  before_filter :prevent_non_admin

  ##
  # Get the page to see all the accompanists and to assign new accompanists
  def new
    @role = Role.new
    @accompanists = User.accompanists
    @users = (User.all - @accompanists)
  end

  ##
  # JSON request to return basic information to user
  def show
    @accompanist = User.find(params[:id])
    render :json => @accompanist
  end

  ##
  # Give accompanist role to a specific user
  def create
    begin
      @accompanist = User.find(params[:role][:user_ids])
      role = Role.find_by_name('Accompagnateur')

      if @accompanist
        @accompanist.roles << role

        if @accompanist.save
          render :json => @accompanist
        else
          render :json => {:message => "L'accompagnateur n'a pu être mis à jour"}, :status => :unprocessable_entity
        end
      else
        render :json => {:message => "L'accompagnateur n'a pu être trouvé"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Erreur lors de la mise à jour de l'accompagnateur"}, :status => :unprocessable_entity
    end
  end

  ##
  # Remove accompanist role to a specific user
  def destroy
    begin
      accompanist = User.find(params[:id])
      role = Role.find_by_name('Accompagnateur')
      roleUser = accompanist.roles.find(role.id)

      if roleUser
        accompanist.roles.delete(roleUser)
        render :json => {:message => "L'accompagnateur a été supprimé avec succès"}, :status => :ok
      else
        render :json => {:message =>  "L'accompagnateur n'a pas été trouvé"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Erreur lors de la suppression de l'accompagnateur"}, :status => :unprocessable_entity
    end
  end
end