class UserSignUp
  attr_reader :error_message, :failed, :successful

  def initialize(user, invitation)
    @user = user
    @invitation = invitation
  end

  def sign_up(stripe_token)
    return unless @user.valid?
    customer = StripeWrapper::Customer.create(
      user: @user,
      card: stripe_token, # obtained with Stripe.js
    )
    subscription = StripeWrapper::Subscription.create(
      customer: customer,
      plan: "basic_plan_id"
    )
      
    if subscription.successful?
      @user.stripe_id = customer.id
      @user.save
      inviter_and_invitee_follow_eachother
      AppMailer.delay.send_welcome_email(@user)
      @successful = true
    else
      @failed = true
      @error_message = subscription.error_message
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
