Rails.configuration.stripe = {
  :publishable_key => ENV['STRIPE_PUBLISHABLE_KEY'],
  :secret_key      => ENV['STRIPE_SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
# StripeEvent.signing_secret = ENV['STRIPE_SIGNING_SECRET'] TODO: start useing this

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    object = event.data.object
    user = User.find_by(stripe_id: object.customer)

    Payment.create(user: user, amount: object.amount, reference_id: object.id)
  end

  events.subscribe 'charge.failed' do |event|
    object = event.data.object
    user = User.find_by(stripe_id: object.customer)

    user.deactivate!
  end

  events.subscribe 'customer.subscription.deleted' do |event|
    object = event.data.object
    user = User.find_by(stripe_id: object.customer)

    user.deactivate!
  end

  events.subscribe 'customer.subscription.updated' do |event|
    object = event.data.object
    user = User.find_by(stripe_id: object.customer)

    user.subscriptions.last.update_column('cancel_at_period_end', true)
  end

  events.subscribe 'customer.subscription.created' do |event|
    object = event.data.object
    user = User.find_by(stripe_id: object.customer)

    Subscription.create(user: user, amount: object.plan.amount,
                        reference_id: object.id,
                        current_period_start: object.current_period_start,
                        current_period_end: object.current_period_end)
  end
end
