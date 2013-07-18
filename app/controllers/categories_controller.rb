class CategoriesController < ApplicationController

  def show
    @category = Category.find(params[:id])
    condition = ["? BETWEEN min AND max", current_user.age]
    respond_to do |format|
      format.json { render :json => {:category =>  @category, :agegroup =>  @category.agegroups.where(condition).first}}
    end
  end

end

