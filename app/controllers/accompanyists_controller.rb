class AccompanyistsController < ApplicationController
  def new
    @accompanyist = User.new
    @accompanyist.contactinfo ||= Contactinfo.new
    @accompanyist.contactinfo.city ||= City.new
    @accompanyists = User.all(:joins => :roles, :conditions => {:roles => { :name => 'accompagnateur'}})
    @users = (User.all - @accompanyists)
  end

  def update
    begin
      @accompanyist = User.find(params[:id])
      role = Role.where(name: 'accompagnateur').first

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
      role = Role.where(name: 'accompagnateur').first
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

  def show
    @accompanyist = User.find(params[:id])
    render :json => @accompanyist
  end
end