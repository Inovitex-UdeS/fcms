##
# Handle JSON requests to retrieve required information when selecting a category in registration form
class CategoriesController < ApplicationController

  ##
  # JSON request to retrieve category information and associated [Agegroup] of the current_user
  def show
    @category = Category.find(params[:id])
    condition = ["? BETWEEN min AND max", current_user.age]
    respond_to do |format|
      format.json { render :json => {:category =>  @category, :agegroup =>  @category.agegroups.where(condition).first}}
    end
  end

end

