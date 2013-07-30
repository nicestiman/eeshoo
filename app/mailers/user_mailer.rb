class UserMailer < ActionMailer::Base
  default from: "user@hiwipi.com"

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "welcome" )
  end
end
