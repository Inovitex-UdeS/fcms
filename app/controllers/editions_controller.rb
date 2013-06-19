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
        render :json => {:errors => @edition.errors.full_messages, :status => 422}.to_json
      end
    rescue
      render :json => {:errors => @edition.errors.full_messages, :status => 422}.to_json
    end
  end

  def destroy
    begin
      @edition = Edition.find(params[:id])
      if @edition
        @edition.destroy
        render :json => "L'édition a été supprimé avec succès", :status => 200
      else
        render :json => { :errors => "L'édition n'a pas été trouvé" }, :status => 404
      end
    rescue
      render :json => { :errors => "Erreur lors de la suppression de l'édition" }, :status => 404
    end
  end

  def update
    begin
      @edition = Edition.find(params[:id])
      if @edition
        if @edition.update_attributes(params[:edition])
          render :json => @edition
        else
          render :json => "L'édition n'a pu être mis à jour", :status => 404
        end
      else
        render :json => { :errors =>  "L'édition n'a pas été trouvé"}, :status => 404
      end
    rescue
      render :json => { :errors => "Erreur lors de la mise à jour de l'édition" }, :status => 404
    end
  end

end
