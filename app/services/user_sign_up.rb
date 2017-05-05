class UserSignUp
  attr_reader :error_message, :failed, :successful

  def initialize(user, invitation)
    @user = user
    @invitation = invitation
  end

  def sign_up(stripe_token)
    return unless @user.valid?
    charge = StripeWrapper::Charge.create(
      amount: 999,
      source: stripe_token, # obtained with Stripe.js
      description: "test charge for #{@user.email}"
    )
    if charge.successful?
      @user.save
      inviter_and_invitee_follow_eachother
      AppMailer.delay.send_welcome_email(@user)
      @successful = true
    else
      @failed = true
      @error_message = charge.error_message
    end
  end

  private

  def inviter
    User.find(@invitation.inviter_id) if @invitation
  end

  def inviter_and_invitee_follow_eachother
    return unless @invitation
    @user.follow(inviter)
    inviter.follow(@user)
    @invitation.update_column(:token, nil)
  end
end
