#encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def prevent_non_admin
    redirect_to root_path, :alert => 'Accès non-autorisé!' unless current_user.is_admin?
  end

  def prevent_unconfirmed_judge
    if  current_user.has_role?('Juge')
      redirect_to root_path, :alert => 'Accès non-autorisé!' unless current_user.is_judge?
    end
  end

end
