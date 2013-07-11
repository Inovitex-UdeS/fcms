#encoding: utf-8
class Admin::PlanificationController < ApplicationController
  before_filter :prevent_non_admin

  def index
  end

  def categories
    selected_category = Category.find(params[:id])
    registrations = Registration.all(:joins => :users, :conditions => {:category_id => params[:id]})

    render :json => {
        :id => selected_category.id,
        :name => selected_category.name,
        :registrations =>
            registrations.as_json(:include => :users
        )
    }
  end
end
