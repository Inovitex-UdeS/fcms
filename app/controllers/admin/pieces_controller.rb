#encoding: utf-8
class Admin::PiecesController < ApplicationController

  def new
    @piece = Piece.new
    @piece.composer ||= Composer.new
    @pieces = Piece.all
  end

  def create
    begin
      @piece = Piece.new(params[:piece])
      if @piece.save
        render :json => @piece.to_json(:include => {:composer => {}} )
      else
        render :json => {:message => @piece.errors.full_messages}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => @piece.errors.full_messages}, :status => :unprocessable_entity
    end
  end

  def destroy
    begin
      @piece = Piece.find(params[:id])
      if @piece
        @piece.destroy
        render :json => {:message => "La pièce a été supprimée avec succès"}, :status => :ok
      else
        render :json => {:message => "La pièce n'a pas été trouvée"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Erreur lors de la suppression de la pièce"}, :status => :unprocessable_entity
    end
  end

  def update
    begin
      @piece = Piece.find(params[:id])
      if @piece
        if @piece.update_attributes(params[:piece])
          render :json => @piece.to_json(:include => {:composer => {}} )
        else
          render :json =>{:message => "La pièce n'a pu être mise à jour"}, :status => :unprocessable_entity
        end
      else
        render :json => {:message =>  "La pièce n'a pas été trouvée"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Erreur lors de la mise à jour de la pièce"}, :status => :unprocessable_entity
    end
  end

  def show
    @piece = Piece.find(params[:id])
    render :json => @piece.to_json(:include => {:composer => {}} )
  end

end
