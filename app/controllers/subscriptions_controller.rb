class SubscriptionsController < ApplicationController
  before_action :require_user

  def index
    @subscriptions = Subscription.where(user: current_user).decorate
  end

  def destroy
    subscription = Subscription.find(params[:id])
    StripeWrapper::Subscription.cancel(subscription)
    flash[:success] = "Your subscription has been set to cancel at the end of the billing period."
    redirect_to home_path
  end
end
