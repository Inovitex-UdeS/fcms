#encoding: utf-8
class Admin::AccompanyistsController < ApplicationController
  def new
    @role = Role.new
    @accompanyists = User.accompanyists
    @users = (User.all - @accompanyists)
  end

  def show
    @accompanyist = User.find(params[:id])
    render :json => @accompanyist
  end

  def create
    begin
      @accompanyist = User.find(params[:role][:user_ids])
      role = Role.find_by_name('Accompagnateur')

      if @accompanyist
        @accompanyist.roles << role

        if @accompanyist.save
          render :json => @accompanyist
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

  def destroy
    begin
      accompanyist = User.find(params[:id])
      role = Role.find_by_name('Accompagnateur')
      roleUser = accompanyist.roles.find(role.id)

      if roleUser
        accompanyist.roles.delete(roleUser)
        render :json => {:message => "L'accompagnateur a été supprimé avec succès"}, :status => :ok
      else
        render :json => {:message =>  "L'accompagnateur n'a pas été trouvé"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Erreur lors de la suppression de l'accompagnateur"}, :status => :unprocessable_entity
    end
  end

end