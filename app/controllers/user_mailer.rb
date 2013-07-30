##
# Mailer class to send custom emails to users in the application through SMTP server
class UserMailer < ActionMailer::Base
  default from: 'portail@inovitex.com' # FROM email -> No response

  ##
  # Send a single email
  #
  # @param [Array] users
  #   The users to send email to
  # @param [String] body
  #   The body of the email
  # @param [String] subject
  #   The subject of the email
  def batch_email(users, body, subject)
    users.each do |u|
      send_email(u,body,subject).deliver
    end
  end

  ##
  # Send a single email
  #
  # @param [User] user
  #   The user to send email to
  # @param [String] body
  #   The body of the email
  # @param [String] subject
  #   The subject of the email
  def send_email(user, body, subject)
    mail(to: "#{user.name} <#{user.email}>",
         body: body,
         content_type: "text/html",
         subject: subject) # Rails method to send emails -> CHEERS!
  end
end