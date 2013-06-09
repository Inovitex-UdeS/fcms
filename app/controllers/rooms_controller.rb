class RoomsController < ApplicationController
  def new
    @room = Room.new
    @rooms = Room.all
  end

  def create
    begin
      capacity = params[:room][:capacity]
      name = params[:room][:name]
      location = params[:room][:location]
      description = params[:room][:description]

      @room = Room.create(capacity: capacity, name: name, location: location, description: description)

      if @room.save
        redirect_to :action => 'new'
      else
        render :json => { :errors => @room.errors.full_messages }, :status => 422
      end

    rescue

    end
  end
end
