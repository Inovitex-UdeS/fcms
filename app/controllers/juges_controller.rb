#encoding: utf-8
class JugesController < ApplicationController
  def new
    @juge = User.new
    @juge.contactinfo ||= Contactinfo.new
    @juge.contactinfo.city ||= City.new
    @juges = User.all(:joins => :roles, :conditions => {:roles => { :name => 'juge'}})
    @users = (User.all - @juges)
  end

  def update
    begin
      @juge = User.find(params[:id])
      role = Role.where(name: 'juge').first

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
      role = Role.where(name: 'juge').first
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

  def show
    @user = User.find(params[:id])
    render :json => @user
  end
end
