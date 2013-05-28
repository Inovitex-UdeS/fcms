class UsersController < ApplicationController
  puts 'Hello'
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Mise a jour du profil"
      sign_in @user
      redirect_to root_path
    else
      render 'edit'
    end
  end

end
