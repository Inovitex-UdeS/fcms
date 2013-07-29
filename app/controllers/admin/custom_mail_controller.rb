class Admin::CustomMailController < ApplicationController

  def index
    @roles = Role.all(:conditions => (["name != ?", 'Administrateur']))
  end

  def new
    @mailtos = params['custom_mail']['mailto']
    @body = params['custom_mail']['body']
    @subject = params['custom_mail']['title']

    # Send email to every users of every targeted role.
    @mailtos.each do |role_id|
      UserMailer.batch_email(Role.find(role_id).users, @body, @subject)
    end
  end
end

