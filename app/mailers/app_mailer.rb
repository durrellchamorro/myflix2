class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail to: user.email, from: "info@durrellsnetflix.herokuapp.com", subject: "Welcom To MyFLIX!"
  end

  def send_forgot_password(user)
    @user = user

    user.generate_token
    mail to: user.email, from: "info@durrellsnetflix.herokuapp.com", subject: "Plsease reset your password"
  end

  def send_invitation_email(invitation)
    @invitation = invitation
    mail to: invitation.recipient_email, from: User.find(invitation.inviter_id).email, subject: "Please join MyFLIX"
  end
end
