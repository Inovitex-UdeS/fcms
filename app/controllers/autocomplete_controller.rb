class AutocompleteController < ApplicationController

  def cities
    @cities = City.all
    render :json => @cities.collect {|o| {:label => o.name, :value => o.id.to_s}}
  end

  def schools
    @schools = School.all
    render :json => @schools.collect {|o| {:label => o.name, :value => o.id.to_s}}
  end

end
