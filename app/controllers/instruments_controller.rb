#encoding: utf-8
class InstrumentsController < ApplicationController
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
        render :json => {:message => @instrument.errors.full_messages, :status => 422}.to_json
      end
    rescue
      render :json => {:message => @instrument.errors.full_messages, :status => 422}.to_json
    end
  end

  def destroy
    begin
      instrument = Instrument.find(params[:id])
      if instrument
        instrument.destroy
        render :json => {:message => "L'instrument a été supprimé avec succès", :status => 200}.to_json
      else
        render :json => {:message =>  "L'instrument n'a pas été trouvé", :status => 404 }.to_json
      end
    rescue
      render :json => {:message => "Erreur lors de la suppression de l'instrument", :status => 404}.to_json
    end
  end

  def update
    begin
      @instrument = Instrument.find(params[:id])
      if @instrument
        if @instrument.update_attributes(params[:instrument])
          render :json => @instrument
        else
          render :json => {:message => "L'instrument n'a pu être mis à jour", :status => 404 }.to_json
        end
      else
        render :json => {:message => "L'instrument n'a pas été trouvé", :status => 404 }.to_json
      end
    rescue
      render :json => {:message => "Erreur lors de la mise à jour de l'instrument", :status => 404}.to_json
    end
  end

end
