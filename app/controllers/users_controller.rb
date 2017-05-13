class UsersController < ApplicationController
  before_action :require_user, only: [:show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    user_sign_up = UserSignUp.new(@user, invitation)

    user_sign_up.sign_up(params[:stripeToken])
    if user_sign_up.successful
      flash[:success] = "You signed up successfully."
      redirect_to login_path
    elsif user_sign_up.failed
      flash[:danger] = user_sign_up.error_message
      render :new
      return
    else
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

  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(params[:id])

    if @user.try(:update, user_params)
      flash.now[:success] = "Your account was successfully updated."
    else
      flash.now[:danger] = "Please try again."
    end

    render :edit
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end

  def invitation
    Invitation.find_by(token: params[:token])
  end
end
