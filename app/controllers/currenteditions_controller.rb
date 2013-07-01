#encoding: utf-8
class CurrenteditionsController < ApplicationController

  def create
    begin
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
  end
end
