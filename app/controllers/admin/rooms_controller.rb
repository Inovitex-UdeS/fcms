#encoding: utf-8
class Admin::RoomsController < ApplicationController
  def new
    @room = Room.new
    @rooms = Room.all
  end

  def create
    begin
      @room = Room.new(params[:room])

      if @room.save
        render :json => @room
      else
        render :json => {:message => @room.errors.full_messages}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => @room.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  def destroy
    begin
      @room = Room.find(params[:id])
      if @room
        @room.destroy
        render :json => {:message => "La salle a été supprimée avec succès"}, :status => :ok
      else
        render :json => {:message =>  "La salle n'a pas été trouvée"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Erreur lors de la suppression de la salle"}, :status => :unprocessable_entity
    end
  end

  def update
    begin
      @room = Room.find(params[:id])
      if @room
        if @room.update_attributes(params[:room])
          render :json => @room
        else
          render :json => {:message => "La salle n'a pu être mise à jour"}, :status => :unprocessable_entity
        end
      else
        render :json => {:message => "La salle n'a pas été trouvée"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Erreur lors de la mise à jour de la salle"}, :status => :unprocessable_entity
    end
  end

  def show
    @room = Room.find(params[:id])
    render :json => @room
  end

end
