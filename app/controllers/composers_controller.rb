#encoding: utf-8
class ComposersController < ApplicationController
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
