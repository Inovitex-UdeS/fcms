class Admin::CategoriesController < ApplicationController
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

  def new
    @categories = Category.all
    @category = Category.new

    @agegroups = Agegroup.where(:category_id => Category.first()[:id])
    @agegroup  = Agegroup.new
  end

  def show
    @category = Category.find(params[:id])
    @agegroups = Agegroup.where(:category_id => @category[:id])
    render :json => {
      :category => @category,
      :agegroups => @agegroups
    }
  end

  def destroy
    begin
      category = Category.find(params[:id])

      if category
        category.destroy
        render :json => {:message => "Le juge a été supprimé avec succès"}, :status => :ok
      else
        render :json => {:message =>  "Le juge n'a pas été trouvé"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Erreur lors de la suppression du juge"}, :status => :unprocessable_entity
    end
  end
end

