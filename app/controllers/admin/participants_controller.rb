#encoding: utf-8

##
# Admin controller to give or remove participant role to a user
class Admin::ParticipantsController < ApplicationController
  before_filter :prevent_non_admin

  ##
  # Get the page to see all the participants and to assign new participants
  def new
    @role = Role.new
    @participants = User.participants
    @users = (User.all - @participants)
  end

  ##
  # JSON request to return basic information about a user
  def show
    @participants = User.find(params[:id])
    render :json => @participants
  end

  ##
  # Give participant role to a specific user
  def create
    begin
      @participant = User.find(params[:role][:user_ids])
      role = Role.find_by_name('Participant')

      if @participant
        @participant.roles << role

        if @participant.save
          render :json => @participant
        else
          render :json => {:message => "Le participant n'a pu être mis à jour"}, :status => :unprocessable_entity
        end
      else
        render :json => {:message => "Le participant n'a pu être trouvé"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Erreur lors de la mise à jour du participant"}, :status => :unprocessable_entity
    end
  end

  ##
  # Remove participant role to a specific user
  def destroy
    begin
      participant = User.find(params[:id])
      role = Role.find_by_name('Participant')
      roleUser = participant.roles.find(role.id)

      if roleUser
        participant.roles.delete(roleUser)
        render :json => {:message => "Le participant a été supprimé avec succès"}, :status => :ok
      else
        render :json => {:message =>  "Le participant n'a pas été trouvé"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Erreur lors de la suppression du participant"}, :status => :unprocessable_entity
    end
  end
end