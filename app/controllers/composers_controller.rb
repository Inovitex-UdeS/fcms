#encoding: utf-8
class ComposersController < ApplicationController

  def new
    @composer = Composer.new
    @composers = Composer.all
  end

  def create
    begin
      @composer = Composer.new(params[:composer])
      if @composer.save
        render :json => @composer
      else
        render :json => {:message => @composer.errors.full_messages}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => @composer.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  def destroy
    begin
      @composer = Composer.find(params[:id])
      if @composer
        @composer.destroy
        render :json => {:message => "Le compositeur a été supprimé avec succès"}, :status => :ok
      else
        render :json => {:message => "Le compositeur n'a pas été trouvé"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Erreur lors de la suppression du compositeur"}, :status => :unprocessable_entity
    end
  end

  def update
    begin
      @composer = Composer.find(params[:id])
      if @composer
        if @composer.update_attributes(params[:composer])
          render :json => @composer
        else
          render :json =>{:message => "Le compositeur n'a pu être mis à jour"}, :status => :unprocessable_entity
        end
      else
        render :json => {:message =>  "Le compositeur n'a pas été trouvé"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Erreur lors de la mise à jour du compositeur"}, :status => :unprocessable_entity
    end
  end

end
