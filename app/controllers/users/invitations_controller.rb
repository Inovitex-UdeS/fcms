class Users::InvitationsController < Devise::InvitationsController
  def new
    @user = User.new
    @user.contactinfo ||= Contactinfo.new
    @user.contactinfo.city ||= City.new

    @roles = Role.all
  end

  def create
    begin
      first_name  = params[:user][:first_name]
      last_name   = params[:user][:last_name]
      birthday    = Date.today
      email       = params[:user][:email]

      telephone   = '8195554444'
      address     = 'Adresse'
      postal_code = 'XXXXXX'
      province    = 'Québec'

      city        = City.first.id

      contactinfo = Contactinfo.create(telephone: telephone, address: address, city_id: city, province: province, postal_code: postal_code)

      @user = User.create(last_name: last_name, first_name: first_name, gender: true, birthday: birthday, email: email, password: 'password', contactinfo_id: contactinfo.id, confirmed_at: Time.now)
      @user.invite!(current_user)

      render root_path
    end
  end
end