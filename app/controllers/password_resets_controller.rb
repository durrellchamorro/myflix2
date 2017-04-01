class PasswordResetsController < ApplicationController
  def show
    user = User.find_by(token: params[:token])
    if user
      @token = user.token
    else
      redirect_to expired_token_path
    end
  end

  def expired_token

  end

  def create
    user = User.find_by(token: params[:token])
    if user
      user.update(password: params[:password], token: nil)
      flash[:success] = "Password updated successfully"
      redirect_to login_path
    else
      redirect_to expired_token_path
    end
  end
end
