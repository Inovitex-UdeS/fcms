class UserMailer < ActionMailer::Base
  default from: 'portail@inovitex.com'

  def batch_email(users, body, subject)
    users.each do |u|
      send_email(u,body,subject).deliver
    end
  end

  def send_email(user, body, subject)
    mail(to: "#{user.name} <#{user.email}>",
         body: body,
         content_type: "text/html",
         subject: subject)
  end
end