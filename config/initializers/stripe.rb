Rails.configuration.stripe = {
  :publishable_key => ENV['STRIPE_PUBLISHABLE_KEY'],
  :secret_key      => ENV['STRIPE_SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    object = event.data.object
    user = User.find_by(stripe_id: object.customer)

    Payment.create(user: user, amount: object.amount, reference_id: object.id)
  end
end
