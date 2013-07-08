class Admin::DashboardController < ApplicationController
  before_filter :prevent_non_admin

  def index
  end
end
