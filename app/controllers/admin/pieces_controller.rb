#encoding: utf-8

##
# Controller to manipulate pieces in the application
class Admin::PiecesController < ApplicationController
  before_filter :prevent_non_admin

  ##
  # Handle JSON request for ajax dataTables
  def index
    render json: PiecesDatatable.new(view_context)
  end

  ##
  # Get the page to display all the current pieces in the application
  def new
    @piece = Piece.new
    @piece.composer ||= Composer.new
    @pieces = Piece.all
  end

  ##
  # Create a new piece
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

  ##
  # Delete a piece, will fail if piece is linked to performances
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
      render :json => {:message => "L'oeuvre est liée à d'autres objets dans la base de données (inscriptions). Veuillez les supprimer en premier."}, :status => :unprocessable_entity
    end
  end

  ##
  # Update information of a piece
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

  ##
  # JSON request to return basic information of a piece
  def show
    @piece = Piece.find(params[:id])
    render :json => @piece.to_json(:include => {:composer => {}} )
  end

end
