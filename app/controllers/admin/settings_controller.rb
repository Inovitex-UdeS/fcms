#encoding: utf-8

##
# Controller to manipulate settings in the application
class Admin::SettingsController < ApplicationController
  before_filter :prevent_non_admin

  ##
  # Update settings
  def create
    begin
      if params[:edition]
        @current_edition = Setting.find_by_key('current_edition_id')
        if @current_edition
          if @current_edition.update_attribute(:value, params[:edition][:id])
            render :json => @current_edition
          else
            render :json =>{:message => "L'édition courante n'a pu être mise à jour"}, :status => :unprocessable_entity
          end
        else
          render :json => {:message =>  "L'édition courante n'a pas été trouvée"}, :status => :unprocessable_entity
        end
      end

      if params[:home_message]
        setting = Setting.find_by_key('home_message')
        begin
          setting.value = params[:home_message]
          setting.save
          render :json => {:message => 'Le message de la page de nouvelles a été mis à jour.'}, :status => :ok
        rescue
          render :json => {:message => 'Le message de la page de nouvelles n\'a pas pu être mis à jour.'}, :status => :unprocessable_entity
        end
      end
    end
  end
end
