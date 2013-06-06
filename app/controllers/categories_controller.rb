class CategoriesController < ApplicationController
  def index

    if params[:id]
      @category = Category.find(params[:id])
      condition = ["? BETWEEN max AND min", current_user.birthday]
      respond_to do |format|
        format.json { render :json => {:category =>  @category, :max_duration =>  @category.agegroups.where(condition).first}}
      end
    else
      @categories = Category.all
    end

  end
end

