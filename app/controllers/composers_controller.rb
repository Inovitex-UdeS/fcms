#encoding: utf-8

##
# Controller to create composers when trying to create a registration
class ComposersController < ApplicationController

  ##
  # Create the composer from Ajax request (will need eventually to validate the composer with a regex...)
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
end
