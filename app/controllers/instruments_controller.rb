class InstrumentsController < ApplicationController
  def new
    @instrument = Instrument.new
    @instruments = Instrument.all
  end

  def create
    begin
      name = params[:instrument][:name]

      @instrument = Instrument.create(name: name)

      if @instrument.save
        render :json => @instrument
      else
        render :json => { :errors => @instrument.errors.full_messages }, :status => 422
      end

    rescue

    end
  end
end
