class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index

    # Will call index view by default
  end

end
