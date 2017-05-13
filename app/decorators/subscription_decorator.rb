class SubscriptionDecorator < Draper::Decorator
  delegate_all
  
  # this doesn't seem to be working which is why I'm setting @paginatable_subscriptions and
  # @decoratable_subscriptions in SubscriptionsController#index
  delegate :current_page, :total_pages, :limit_value, :entry_name, :total_count, :offset_value, :last_page?

  def print_current_period_start
    Time.at(current_period_start).strftime("%m/%d/%Y")
  end

  def print_current_period_end
    Time.at(current_period_end).strftime("%m/%d/%Y")
  end
end
