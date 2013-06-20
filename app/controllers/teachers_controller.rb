#encoding: utf-8
class TeachersController < ApplicationController
  def new
    @teacher = User.new
    @teacher.contactinfo ||= Contactinfo.new
    @teacher.contactinfo.city ||= City.new
    @teachers = User.all(:joins => :roles, :conditions => {:roles => { :name => 'professeur'}})
    @users = (User.all - @teachers)
  end

  def update
    begin
      @teacher = User.find(params[:id])
      role = Role.where(name: 'Professeur').first

      if @teacher
        @teacher.roles << role

        if @teacher.save
          render :json => @teacher
        else
          render :json => {:message => "Le professeur n'a pu être mis à jour"}, :status => :unprocessable_entity
        end
      else
        render :json => {:message => "Le professeur n'a pu être trouvé"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Erreur lors de la mise à jour du professeur"}, :status => :unprocessable_entity
    end
  end

  def destroy
    begin
      teacher = User.find(params[:id])
      role = Role.where(name: 'professeur').first
      roleUser = teacher.roles.find(role.id)

      if roleUser
        teacher.roles.delete(roleUser)
        render :json => {:message => "Le professeur a été supprimé avec succès"}, :status => :ok
      else
        render :json => {:message =>  "Le professeur n'a pas été trouvé"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Erreur lors de la suppression du professeur"}, :status => :unprocessable_entity
    end
  end

  def show
    @teacher = User.find(params[:id])
    render :json => @teacher
  end
end