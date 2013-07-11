#encoding: utf-8
class Admin::JugesController < ApplicationController
  before_filter :prevent_non_admin

  def new
    @role = Role.new
    @ujuges = User.unconfirmed_juges
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

  def confirm
    begin
      user_id = params[:id]
      role_id = Role.find_by_name('Juge').id
      @roles_user = RolesUser.where("user_id=#{user_id} AND role_id=#{role_id}").first

      if !@roles_user
        redirect_to new_admin_juge_path, :alert => 'Le juge n\'a pas été confirmé...'
      end

      @roles_user.update_attribute(:confirmed, true)

      redirect_to new_admin_juge_path, :notice => 'Le juge a bien été confirmé!'
    rescue => e
      redirect_to new_admin_juge_path, :alert => 'Le juge n\'a pas été confirmé...'
    end
  end

  def reject
    begin
      user_id = params[:id]
      role_id = Role.find_by_name('Juge').id
      @roles_user = RolesUser.where("user_id=#{user_id} AND role_id=#{role_id}").first

      if !@roles_user
        redirect_to new_admin_juge_path, :alert => 'Le juge n\'a pas été rejeté...'
      end

      @roles_user.destroy()

      redirect_to new_admin_juge_path, :notice => 'Le juge a bien été rejeté!'
    rescue => e
      redirect_to new_admin_juge_path, :alert => 'Le juge n\'a pas été rejeté...'
    end
  end

end
