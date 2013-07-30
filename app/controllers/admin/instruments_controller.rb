#encoding: utf-8
class Admin::InstrumentsController < ApplicationController
  before_filter :prevent_non_admin

  def new
    @instrument = Instrument.new
    @instruments = Instrument.all
  end

  def create
    begin
      @instrument = Instrument.new(params[:instrument])

      if @instrument.save
        render :json => @instrument
      else
        render :json => {:message => @instrument.errors.full_messages}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => @instrument.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  def destroy
    begin
      instrument = Instrument.find(params[:id])
      if instrument
        instrument.destroy
        render :json => {:message => "L'instrument a été supprimé avec succès"}, :status => :ok
      else
        render :json => {:message =>  "L'instrument n'a pas été trouvé"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "L'instrument est lié à d'autres objets dans la base de données (inscriptions). Veuillez les supprimer en premier."}, :status => :unprocessable_entity
    end
  end

  def update
    begin
      @instrument = Instrument.find(params[:id])
      if @instrument
        if @instrument.update_attributes(params[:instrument])
          render :json => @instrument
        else
          render :json => {:message => "L'instrument n'a pu être mis à jour"}, :status => :unprocessable_entity
        end
      else
        render :json => {:message => "L'instrument n'a pas été trouvé"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Erreur lors de la mise à jour de l'instrument"}, :status => :unprocessable_entity
    end
  end

  def show
    @instrument = Instrument.find(params[:id])
    render :json => @instrument
  end
end
