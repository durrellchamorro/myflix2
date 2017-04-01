class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail to: user.email, from: "info@myflix.com", subject: "Welcom To MyFlix!"
  end

  def send_forgot_password(user)
    @user = user
    
    user.generate_token
    mail to: user.email, from: "info@myflix.com", subject: "Plsease reset your password"
  end
end
