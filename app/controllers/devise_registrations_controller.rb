class DeviseRegistrationsController < Devise::RegistrationsController
  def create
    if verify_recaptcha( :timeout => 30)
      super
    else
      build_resource
      clean_up_passwords(resource)
      resource.errors.messages[:captcha] = [ 'est incorrecte' ]
      render :new
    end
  end

  def edit
    super
  end

  def show
    super
  end

end