class CitiesController < ApplicationController

  def autocomplete
    @autocomplete_cities = City.all

    #response = { :moulding => @autocomplete_cities }
    #render :json => response

    render :json => @autocomplete_cities.collect {|o| {:label => o.name, :value => o.id.to_s}}

  end


  def show
    @city = City.new

    respond_to do |format|
      format.html
    end

  end



end
