class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def edit
    @user  = User.find(params[:id])
    @user.contactinfo ||= Contactinfo.new
    @user.contactinfo.city ||= City.new
  end

  def update
    @user = User.find(params[:id])
    #city = City.find(:name => @user.contactinfo.city.)
    #@user.contactinfo.city.update_attributes(params[:city])
    if @user.update_attributes(params[:user])
      flash[:success] = "Mise a jour du profil"
      sign_in @user
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def show
    @user = User.find(params[:id])
    render :json => @user
  end

end
