#encoding: utf-8
class EditionsController < ApplicationController
  def new
    @edition = Edition.new
    @editions = Edition.all
  end

  def create
    begin
      @edition = Edition.new(params[:edition])
      if @edition.save
        render :json => @edition
      else
        render :json => {:message => @edition.errors.full_messages, :status => 422}.to_json
      end
    rescue
      render :json => {:message => @edition.errors.full_messages, :status => 422}.to_json
    end
  end

  def destroy
    begin
      @edition = Edition.find(params[:id])
      if @edition
        @edition.destroy
        render :json => {:message => "L'édition a été supprimé avec succès", :status => 200 }.to_json
      else
        render :json => {:message => "L'édition n'a pas été trouvé" , :status => 404}.to_json
      end
    rescue
      render :json => {:message => "Erreur lors de la suppression de l'édition" , :status => 404}.to_json
    end
  end

  def update
    begin
      @edition = Edition.find(params[:id])
      if @edition
        if @edition.update_attributes(params[:edition])
          render :json => @edition
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
