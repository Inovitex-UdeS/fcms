#encoding: utf-8
class Admin::TimeslotsController < ApplicationController
  before_filter :prevent_non_admin
  #TODO: remove this line after debugging
  protect_from_forgery :except => [ :create, :update, :destroy ]

  ##
  # JSON request to return information about a specific timeslot
  def show
    begin
      @timeslot = Timeslot.find(params[:id])
      render :json => @timeslot.as_json
    rescue
      render :json => { :message => 'Impossible de trouver la plage horaire #' + params[:id] }, :status => :expectation_failed
    end
  end

  ##
  # Custom "create" request, handles create and update
  def create
    begin
      if (params[:id] > -1)
        timeslot = Timeslot.find(params[:id])
      else
        timeslot = Timeslot.new
      end
      setAttributesFromJSON(timeslot, params)
    rescue
      render :json => {:message => 'Erreur lors de la mise à jour de la plage horaire.' }, :status => :expectation_failed
    end
  end

  ##
  # Remove registrations from timeslot and delete timeslot
  def destroy
    begin
      timeslot = Timeslot.find(params[:id])
      timeslot.registrations.clear
      timeslot.delete
      render :json => { :message => 'La plage horaire a été supprimée avec succès' }, :status => :ok
    rescue
      render :json => { :message => 'Erreur lors de la suppression de la plage horaire' }, :status => :expectation_failed
    end
  end

  ##
  # Custom JSON parser for timeslots, using serialization format provided by Timeslot model
  def setAttributesFromJSON(timeslot, params)
    timeslot.label       = params[:label]
    timeslot.category_id = params[:category_id]
    timeslot.duration    = params[:entered_duration] || 0
    timeslot.edition_id  = Setting.find_by_key('current_edition_id').value

    timeslot.registrations.clear
    if params[:registrations]
      params[:registrations].each do |i|
        timeslot.registrations << Registration.find(i)
      end
    end

    timeslot.save

    render :json => timeslot.as_json
  end
end