class AdminsController < ApplicationController
  before_action :require_admin

  private

  def require_admin
    (flash[:danger] = 'You must be an admin to do that.') && redirect_to(home_path) unless current_user.try(:admin?)
  end
end
