#encoding: utf-8
##
# Base controller for all other controller, we will be defining utility methods in them
class ApplicationController < ActionController::Base
  protect_from_forgery

  ##
  # Make sure that every requests is made by an authenticated user
  before_filter :authenticate_user!

  ##
  # Cancan in not used right now, but eventually we will handle the exceptions here
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  ##
  # Redirect to root if user is not an administrator
  def prevent_non_admin
    redirect_to root_path, :alert => 'Accès non-autorisé!' unless current_user.is_admin?
  end

  ##
  # Redirect to root if user is not a confirmed judge
  def prevent_unconfirmed_judge
    if current_user.has_role?('Juge')
      redirect_to root_path, :alert => 'Accès non-autorisé!' unless current_user.is_judge?
    end
  end

  ##
  # Redirect to root if user is not a participant
  def prevent_non_participant
      redirect_to root_path, :alert => 'Accès non-autorisé!' unless current_user.is_participant?
  end
end
