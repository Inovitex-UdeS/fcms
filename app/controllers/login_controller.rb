class LoginController < ApplicationController
  def create
    response = { :authenticated => (params[:user] == 'test' and params[:password] == "root123") }
    render :json => response
  end
end
