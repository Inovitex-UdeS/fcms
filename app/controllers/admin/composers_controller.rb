#encoding: utf-8

##
# Controller to manipulate composers in the application
class Admin::ComposersController < ApplicationController
  before_filter :prevent_non_admin

  ##
  # Handle JSON request for ajax dataTables
  def index
    render json: ComposersDatatable.new(view_context)
  end

  ##
  # Get the page to display all the current composers in the application
  def new
    @composer = Composer.new
    @composers = Composer.all
  end

  ##
  # Create new composer
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

  ##
  # Delete composer, will fail if composer is linked to a composer
  def destroy
    begin
      @composer = Composer.find(params[:id])
      if @composer
        @composer.destroy
        render :json => {:message => "Le compositeur a été supprimé avec succès"}, :status => :ok
      else
        render :json => {:message => "Le compositeur n'a pas été trouvé"}, :status => :unprocessable_entity
      end
    rescue => e
      render :json => {:message => "Le compositeur est lié à d'autres objets dans la base de données (oeuvres). Veuillez les supprimer en premier."}, :status => :unprocessable_entity
    end
  end

  ##
  # Update composer
  def update
    begin
      @composer = Composer.find(params[:id])
      if @composer
        if @composer.update_attributes(params[:composer])
          render :json => @composer
        else
          render :json =>{:message => "Le compositeur n'a pu être mis à jour"}, :status => :unprocessable_entity
        end
      else
        render :json => {:message =>  "Le compositeur n'a pas été trouvé"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Erreur lors de la mise à jour du compositeur"}, :status => :unprocessable_entity
    end
  end

  ##
  # JSON request to return basic information of a piece
  def show
    @composer = Composer.find(params[:id])
    render :json => @composer
  end
end
