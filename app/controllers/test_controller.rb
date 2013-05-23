class TestController < ApplicationController
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def show
    authorize! :manage, User, :message => "Unable to manage this shit."

  end
end
