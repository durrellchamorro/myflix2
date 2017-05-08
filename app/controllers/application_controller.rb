class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  after_action :prepare_unobtrusive_flash
  rescue_from ActionController::InvalidAuthenticityToken, with: :redirect_to_referer_or_path

  def redirect_to_referer_or_path
    flash[:danger] = "Please try again."
    redirect_to request.referer
  end

  def unobtrusive_flash_keys
    [:notice, :alert, :error, :success, :warning, :danger]
  end

  def require_user
    (flash[:danger] = 'You must be signed in to do that') && redirect_to(login_path) unless current_user
  end

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user
end
