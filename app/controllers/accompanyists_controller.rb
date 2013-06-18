class AccompanyistsController < ApplicationController
  def new
    @accompanyist = User.new
    @accompanyist.contactinfo ||= Contactinfo.new
    @accompanyist.contactinfo.city ||= City.new
    @accompanyists = User.all(:joins => :roles, :conditions => {:roles => { :name => 'accompagnateur'}})
  end

  def create
    begin
      first_name  = params[:user][:first_name]
      last_name   = params[:user][:last_name]
      birthday    = params[:user][:birthday]
      email       = params[:user][:email]

      telephone   = params[:user][:contactinfo_attributes][:telephone]
      address     = params[:user][:contactinfo_attributes][:address]
      address2    = params[:user][:contactinfo_attributes][:address2]
      postal_code = params[:user][:contactinfo_attributes][:postal_code].gsub(/ /,'')
      province    = params[:user][:contactinfo_attributes][:province]

      city_name   = params[:user][:contactinfo_attributes][:city_attributes][:name]
      city        = City.where(:name => city_name).first.id

      contactinfo = Contactinfo.create(telephone: telephone, address: address, address2: address2, city_id: city, province: province, postal_code: postal_code)

      @accompanyist = User.create(last_name: last_name, first_name: first_name, gender: true, birthday: birthday, email: email, password: 'password', contactinfo_id: contactinfo.id, confirmed_at: Time.now)
      @accompanyist.contactinfo = contactinfo

      role = Role.where(:name => 'accompagnateur').first
      @accompanyist.roles  << role

      if @accompanyist.save
        redirect_to :action => 'new'
      else
        render :json => { :errors => "Error creating User" }, :status => 422
      end

    rescue
      render :json => { :errors => "Erreurs" }, :status => 422
    end
  end
end