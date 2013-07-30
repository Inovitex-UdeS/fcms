#encoding: utf-8

##
# Controller to manipulate categories
class Admin::CategoriesController < ApplicationController
  before_filter :prevent_non_admin

  ##
  # Display all the categories
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

  ##
  # Display the page to create new categories
  def new
    @categories = Category.all
    @category = Category.new

    @agegroups = Agegroup.where(:category_id => Category.first()[:id])
    @agegroup  = Agegroup.new
  end

  ##
  # JSON request to reuturn information about a specific category
  def show
    @category = Category.find(params[:id])
    @agegroups = Agegroup.where(:category_id => @category[:id]).where(:edition_id => Setting.find_by_key('current_edition_id').value)
    render :json => {
      :category => @category,
      :agegroups => @agegroups
    }
  end

  ##
  # Destory a category, will fail if the category is linked to registrations
  def destroy
    begin
      category = Category.find(params[:id])

      if category
        Agegroup.find_all_by_category_id(category.id).each do |ag|
          Agegroup.delete(ag)
        end

        category.destroy

        render :json => {:message => "La classe a été supprimé avec succès."}, :status => :ok
      else
        render :json => {:message =>  "La classe n'a pas été trouvée."}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Impossible de procéder: il existe déjà des inscriptions pour cette classe d'inscription."}, :status => :unprocessable_entity
    end
  end

  ##
  # Update information related to a category, will call custom method to handle this
  def update
    begin
      category = Category.find(params[:id])
      if category
        if category.update_attributes(params[:category])
          update_age_groups(params[:agegroups], category)
          render :json => {
              :id => category[:id],
              :name => category[:name],
              :created_at => category.created_at.strftime("%d/%m/%Y"),
              :updated_at => category.updated_at.strftime("%d/%m/%Y")
          }
        else
          render :json =>{:message => "La catégorie n'a pu être mise à jour"}, :status => :unprocessable_entity
        end
      else
        render :json => {:message =>  "La catégorie n'a pas été trouvée"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Erreur lors de la mise à jour de la catégorie"}, :status => :unprocessable_entity
    end
  end

  ##
  # Create request for categories
  def create
    begin
      category = Category.new(params[:category])

      if category.save
        update_age_groups(params[:agegroups], category)
        render :json => {
            :id => category[:id],
            :name => category[:name],
            :created_at => category.created_at.strftime("%d/%m/%Y"),
            :updated_at => category.updated_at.strftime("%d/%m/%Y")
        }
      else
        render :json => {:message => category.errors.full_messages}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => category.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  ##
  # Custom method to handle update of age groups
  def update_age_groups(new_age_groups, category)
    existing_age_groups = []
    new_age_groups.each do |i, ag|
      # Skip if there's no description
      if ag[:description].empty?
        next
      end

      # Create or update age group
      if ag[:id].empty?
        agegroup = Agegroup.new(ag)
        agegroup.category = category
        agegroup.edition_id = Setting.find_by_key('current_edition_id').value
      else
        agegroup = Agegroup.find(ag[:id])
        agegroup.update_attributes(ag)
      end

      # Save updated age group
      agegroup.save
      existing_age_groups.push agegroup.id
    end

    # Remove inexisting age groups
    all_age_groups = category.agegroups.where(:edition_id => Setting.find_by_key('current_edition_id').value)
    all_age_groups.each do |ag|
      unless existing_age_groups.include? ag.id
        ag.destroy
      end
    end
  end

end