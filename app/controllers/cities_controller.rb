class CitiesController < ApplicationController

  def show
    @city = City.new

    respond_to do |format|
      format.html
    end
  end

end
