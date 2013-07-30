##
# Overloaded Devise controller to handle captcha when creating account
class DeviseRegistrationsController < Devise::RegistrationsController

  ##
  # Validate the captcha and use Devise methods to create the account
  # Code as found on GitHub repo [https://github.com/plataformatec/devise/blob/master/app/controllers/devise/registrations_controller.rb]
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

  ##
  # Call Devise edit
  def edit
    super
  end

  ##
  # Call Devise show
  def show
    super
  end
end