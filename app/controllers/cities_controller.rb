class CitiesController < ApplicationController

  autocomplete :city, :name, :full => true

  def show
    @city = City.new
  end

end
