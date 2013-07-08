#encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def prevent_non_admin
    redirect_to root_path, :alert => 'Accès non-authorizé!' unless current_user.is_admin?
  end

end
