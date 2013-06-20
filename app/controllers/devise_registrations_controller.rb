class DeviseRegistrationsController < Devise::RegistrationsController
  def create
    if verify_recaptcha( :timeout => 30)
      super
    else
      build_resource
      clean_up_passwords(resource)
      set_flash_message :notice, :recaptcha
      #flash.now[:alert] = "Il y a eu une erreur avec le code ci-dessous. Veuillez l'entrer à nouveau."
      #flash.delete :recaptcha_error
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