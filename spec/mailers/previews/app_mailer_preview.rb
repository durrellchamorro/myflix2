class AppMailerPreview < ActionMailer::Preview
  def send_welcome_email
    AppMailer.send_welcome_email(User.first)
  end

  def send_forgot_password
    AppMailer.send_forgot_password(User.first)
  end

  def send_invitation_email
    AppMailer.send_invitation_email(Invitation.first)
  end
end
