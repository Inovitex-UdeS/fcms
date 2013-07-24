class UsersController < ApplicationController

  def edit
    @user  = User.find(params[:id])
    @user.contactinfo ||= Contactinfo.new
    @user.contactinfo.city ||= City.new
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { flash[:success] = "Mise a jour du profil"; sign_in @user; redirect_to root_path ;}
        format.json { render json: @user, status: :ok, location: @user  }
      else
        format.html { render 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @user = User.find(params[:id])
    render :json => @user.to_json(:include => {:contactinfo => {:include => :city}})
  end


end
