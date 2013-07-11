class Admin::AgegroupsController < ApplicationController
  def new
    @agegroups = Agegroup.all
    @agegroup = Agegroup.new
  end

  def update
    begin
      @agegroup = Agegroup.find(params[:id])
      if @agegroup
        if @agegroup.update_attributes(ActiveSupport::JSON.decode(params[:agegroup]))
          render :json => @agegroup
        else
          render :json => {:message => "Le groupe d'âge n'a pu être mis à jour"}, :status => :unprocessable_entity
        end
      else
        render :json => {:message => "Le groupe d'âge n'a pas été trouvé"}, :status => :unprocessable_entity
      end
    rescue
      render :json => {:message => "Erreur lors de la mise à jour du groupe d'âge"}, :status => :unprocessable_entity
    end
  end
end