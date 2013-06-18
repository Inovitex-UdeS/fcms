#encoding: utf-8
class UserSignInfosController < ApplicationController

  def edit
    @user = current_user #User.find(params[:id])

  end

  def update
    @user = current_user #User.find(params[:id])

    if params[:user][:password].empty? && params[:user][:password_confirmation].empty? && !params[:user][:email].empty? && !params[:user][:current_password].empty?
      user_hash = {:email => params[:user][:email], :current_password => params[:user][:current_password]}
    elsif !params[:user][:password].empty? && !params[:user][:password_confirmation].empty?
      user_hash = params[:user]
    end

    if (user_hash)
      #if @user.update_attributes(user_hash)
      if @user.update_with_password(user_hash)
        flash[:success] = "Courriel mis à jour"
        sign_in @user
        redirect_to root_path
      else
        redirect_to :back
      end
    end



  end

end
