class SessionsController < ApplicationController
  def new
    redirect_to home_path if current_user
  end

  def create
    user = User.find_by(email: params[:email])

    if user.try(:active) == false
      flash[:danger] = 'Your account is not active. Only active users can sign in.'
      redirect_to login_path
    elsif user.try(:authenticate, params[:password])
      session[:user_id] = user.id
      flash[:success] = 'You are signed in. Enjoy!'
      redirect_to home_path
    else
      flash[:danger] = 'Invalid email or password'
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = 'You signed out successfully'
  end
end
