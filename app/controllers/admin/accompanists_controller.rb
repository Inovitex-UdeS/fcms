#encoding: utf-8
class Admin::AccompanistsController < ApplicationController
  def new
    @role = Role.new
    @accompanists = User.accompanists
    @users = (User.all - @accompanists)
  end

  def show
    @accompanist = User.find(params[:id])
    render :json => @accompanist
  end

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