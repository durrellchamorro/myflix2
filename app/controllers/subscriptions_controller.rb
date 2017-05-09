class SubscriptionsController < ApplicationController
  before_action :require_user

  def index
    @subscriptions = Subscription.where(user: current_user).decorate
  end
end
