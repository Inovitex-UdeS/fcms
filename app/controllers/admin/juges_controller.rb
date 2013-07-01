#encoding: utf-8
class Admin::JugesController < ApplicationController
  def new
    @role = Role.new
    @juges = User.juges
    @users = (User.all - @juges)
  end

  def show
    @juge = User.find(params[:id])
    render :json => @juge
  end

  def create
    begin
      @juge = User.find(params[:role][:user_ids])
      role = Role.find_by_name('Juge')

      if @juge
        @juge.roles << role

        if @juge.save
          render :json => @juge
        else
          render :json => {:message => "Le juge n'a pu être mis à jour"}, :status => :unprocessable_entity
        end
      else
        render :json => {:message => "Le juge n'a pu être trouvé"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Erreur lors de la mise à jour du juge"}, :status => :unprocessable_entity
    end
  end

  def destroy
    begin
      juge = User.find(params[:id])
      role = Role.find_by_name('Juges')
      roleUser = juge.roles.find(role.id)

      if roleUser
        juge.roles.delete(roleUser)
        render :json => {:message => "Le juge a été supprimé avec succès"}, :status => :ok
      else
        render :json => {:message =>  "Le juge n'a pas été trouvé"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Erreur lors de la suppression du juge"}, :status => :unprocessable_entity
    end
  end

end
