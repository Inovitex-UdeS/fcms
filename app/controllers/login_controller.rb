class LoginController < ApplicationController
  def create
    if (params[:user] == 'test' and params[:password] == "root123")
      render :json => {}, :status => :ok
    else
      render :json => {}, :status => :unauthorized
    end
  end
end
