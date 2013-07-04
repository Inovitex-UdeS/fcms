#encoding: utf-8
class Users::InvitationsController < Devise::InvitationsController
  def new
    @user = User.new
    @user.contactinfo ||= Contactinfo.new
    @user.contactinfo.city ||= City.new

    @roles = Role.all
  end

  def create
    begin
      @user = User.new(params[:user])
      @user.update_attribute(:birthday, '1980-05-12')
      @user.update_attribute(:password, 'password')

      if @user.save
        redirect_to new_user_invitation_path, :notice => 'L\'invitation a bien été envoyée!'
      else
        redirect_to new_user_invitation_path, :alert => 'Erreur lors de l\'invitation'
      end
    end
  end
end