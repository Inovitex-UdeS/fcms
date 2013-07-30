class Admin::CustomMailController < ApplicationController

  def new
    @roles = Role.all(:conditions => (["name != ?", 'Administrateur']))
  end

  def create_email
    begin
      @mailtos = params['custom_mail']['mailto']
      @body = params['custom_mail']['body']
      @subject = params['custom_mail']['title']

      # Send email to every users of every targeted role.
      @mailtos.each do |role_id|
        UserMailer.batch_email(Role.find(role_id).users, @body, @subject)
      end


      #hack
      @roles = Role.all(:conditions => (["name != ?", 'Administrateur']))
      redirect_to new_admin_custom_mail_path
    end
  end
end

