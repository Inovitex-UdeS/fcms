#encoding: utf-8

##
# Controller to send email to specific users through SMTP server
class Admin::CustomMailsController < ApplicationController

  ##
  # Get the page to display the send mail page
  def new
    @role = Role.new
    @roles = Role.all(:conditions => (["name != ?", 'Administrateur']))
  end

  ##
  # Send emails to selected users
  def create
    begin
      @mailtos = params['custom_mail']['mailto']
      @body = params['custom_mail']['body']
      @subject = params['custom_mail']['title']

      # Send email to every users of every targeted role.
      @mailtos.each do |role_id|
        UserMailer.batch_email(Role.find(role_id).users, @body, @subject)
      end

      render :json => {"message" => "Le message a été envoyé à tous les destinataires!"}
    end
  end
end
