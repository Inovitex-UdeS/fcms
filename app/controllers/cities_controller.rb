#encoding: utf-8
class CitiesController < ApplicationController

  def new
    @city = City.new
    @cities = City.all
  end

  def create
    begin
      @city = City.new(params[:edition])
      if @city.save
        render :json => @city
      else
        render :json => {:message => @city.errors.full_messages, :status => 422}.to_json
      end
    rescue
      render :json => {:message => @city.errors.full_messages, :status => 422}.to_json
    end
  end

  def destroy
    begin
      @city = City.find(params[:id])
      if @city
        @city.destroy
        render :json => {:message => "La ville a été supprimée avec succès", :status => 200 }.to_json
      else
        render :json => {:message => "La ville n'a pas été trouvée", :status => 404}.to_json
      end
    rescue
      render :json => {:message => "Erreur lors de la suppression de la ville", :status => 404}.to_json
    end
  end

  def update
    begin
      @city = City.find(params[:id])
      if @city
        if @city.update_attributes(params[:city])
          render :json => @city
        else
          render :json =>{:message => "L'édition n'a pu être mis à jour", :status => 404}.to_json
        end
      else
        render :json => {:message =>  "L'édition n'a pas été trouvé", :status => 404}.to_json
      end
    rescue
      render :json => {:message => "Erreur lors de la mise à jour de l'édition", :status => 404}.to_json
    end
  end

end
