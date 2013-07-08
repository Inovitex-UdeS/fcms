#encoding: utf-8
class Admin::TeachersController < ApplicationController
  before_filter :prevent_non_admin

  def new
    @role = Role.new
    @teachers = User.teachers
    @users = (User.all - @teachers)
  end

  def show
    @teacher = User.find(params[:id])
    render :json => @teacher
  end

  def create
    begin
      @teacher = User.find(params[:role][:user_ids])
      role = Role.find_by_name('Professeur')

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
      role = Role.find_by_name('Professeur')
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
end