#encoding: utf-8

##
# Controller to manipulate instruments in the application
class Admin::InstrumentsController < ApplicationController
  before_filter :prevent_non_admin

  ##
  # Get the page to display all the current instruments in the application
  def new
    @instrument = Instrument.new
    @instruments = Instrument.all
  end

  ##
  # Create an instrument
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

  ##
  # Delete an instrument, will fail if it is linked in registrations
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

  ##
  # Update an instrument name
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

  ##
  # JSON request to return basic information about an instrument
  def show
    @instrument = Instrument.find(params[:id])
    render :json => @instrument
  end
end
