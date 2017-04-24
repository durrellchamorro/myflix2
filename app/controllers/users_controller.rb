class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    begin
      if @user.save
        Stripe.api_key = ENV['STRIPE_SECRET_KEY']

        Stripe::Charge.create({
          :amount => 999,
          :currency => "usd",
          :source => params[:stripeToken], # obtained with Stripe.js
          :description => "test charge for #{@user.email}"
        })
        inviter_and_invitee_follow_eachother
        AppMailer.delay.send_welcome_email(@user)
        flash[:success] = "You signed up successfully."
        redirect_to login_path
      else
        render :new
        return
      end
    rescue Stripe::CardError => e
      User.destroy(@user) if @user.persisted?
      @user = User.new(user_params)
      body = e.json_body
      error = body[:error]
      flash[:danger] = error[:message] ? error[:message] : "Please try again."
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def new_with_invitation_token
    if invitation
      @user = User.new(email: invitation.recipient_email, full_name: invitation.recipient_name)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end

  def invitation
    Invitation.find_by(token: params[:token])
  end

  def inviter
    User.find(invitation.inviter_id)
  end

  def inviter_and_invitee_follow_eachother
    if invitation
      @user.follow(inviter)
      inviter.follow(@user)
      invitation.update_column(:token, nil)
    end
  end
end
