class EditionsController < ApplicationController
  def new
    @edition = Edition.new
    @editions = Edition.all
  end

  def create
    begin
      limitDate = params[:edition][:limit_date]
      year = params[:edition][:year]

      @edition = Edition.create(year: year, limit_date: limitDate)

      if @edition.save
        render :json => @edition
      else
        render :json => { :errors => @edition.errors.full_messages }, :status => 422
      end

    rescue

    end
  end
end
