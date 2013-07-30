#encoding: utf-8
class Admin::CustomMailsController < ApplicationController
  def new
    @role = Role.new
    @roles = Role.all(:conditions => (["name != ?", 'Administrateur']))
  end

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
