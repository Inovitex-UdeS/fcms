#encoding: utf-8
class Admin::SchooltypesController < ApplicationController
  def new
    @schooltype = Schooltype.new
    @schooltypes = Schooltype.all
  end

  def create
    begin
      @schooltype = Schooltype.new(params[:schooltype])
      if @schooltype.save
        render :json => @schooltype
      else
        render :json => {:message => @schooltype.errors.full_messages}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => @schooltype.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  def destroy
    begin
      @schooltype = Schooltype.find(params[:id])
      if @schooltype
        @schooltype.destroy
        render :json => {:message => "Le type d'école a été supprimé avec succès"}, :status => :ok
      else
        render :json => {:message => "Le type d'école n'a pas été trouvé"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Erreur lors de la suppression du type d'école"}, :status => :unprocessable_entity
    end
  end

  def update
    begin
      @schooltype = Schooltype.find(params[:id])
      if @schooltype
        if @schooltype.update_attributes(params[:schooltype])
          render :json => @schooltype
        else
          render :json =>{:message => "Le type d'école n'a pu être mis à jour"}, :status => :unprocessable_entity
        end
      else
        render :json => {:message =>  "La type d'école n'a pas été trouvé"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Erreur lors de la mise à jour du type d'école"}, :status => :unprocessable_entity
    end
  end

  def show
    @schooltype = Schooltype.find(params[:id])
    render :json => @schooltype
  end

end
