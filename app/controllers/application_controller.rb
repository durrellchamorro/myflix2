class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def require_user
    (flash[:danger] = 'You must be signed in to do that') && redirect_to(login_path) unless current_user
  end

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  def require_admin
    (flash[:danger] = 'You must be an admin to do that.') && redirect_to(home_path) unless current_user.admin?
  end

  helper_method :current_user
end
