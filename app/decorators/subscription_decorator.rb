class SubscriptionDecorator < Draper::Decorator
  delegate_all

  def print_current_period_start
    Time.at(current_period_start).strftime("%m/%d/%Y")
  end

  def print_current_period_end
    Time.at(current_period_end).strftime("%m/%d/%Y")
  end
end
