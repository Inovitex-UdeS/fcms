#encoding: utf-8

##
# Admin controller to give or remove teacher role to a user
class Admin::TeachersController < ApplicationController
  before_filter :prevent_non_admin

  ##
  # Get the page to see all the teachers and to assign new teachers
  def new
    @role = Role.new
    @teachers = User.teachers
    @users = (User.all - @teachers)
  end

  ##
  # JSON request to return basic information about a user
  def show
    @teacher = User.find(params[:id])
    render :json => @teacher
  end

  ##
  # Give teacher role to a specific user
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

  ##
  # Remove teacher role to a specific user
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