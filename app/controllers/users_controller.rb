##
# JSON request to get user information
class UsersController < ApplicationController

  ##
  # Will return profile page to edit personal information
  def edit
    @user  = User.find(params[:id])
    @user.contactinfo ||= Contactinfo.new
    @user.contactinfo.city ||= City.new
  end

  ##
  # Handle modifications to profile
  def update
    @user = User.find(params[:id])

    # Right now we handle only html request, but in later iteration, we will handle json
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { flash[:success] = "Mise a jour du profil"; sign_in @user; redirect_to root_path;}
        format.json { render json: @user, status: :ok, location: @user  }
      else
        format.html { render 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  ##
  # JSON request to get user information
  def show
    @user = User.find(params[:id])
    render :json => @user.to_json(:include => {:contactinfo => {:include => :city}})
  end
end
