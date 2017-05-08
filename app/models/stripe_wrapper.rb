module StripeWrapper
  class Charge
    attr_reader :error_message, :response

    def initialize(response: nil, error_message: nil)
      @response = response
      @error_message = error_message
    end

    def self.create(amount:, source:, description:)
      response = Stripe::Charge.create(
        amount: amount,
        currency: 'usd',
        source: source,
        description: description
      )
      new(response: response)
    rescue Stripe::CardError => e
      body = e.json_body
      error = body.dig(:error, :message)
      new(error_message: error)
    end

    def successful?
      response.present?
    end
  end

  class Customer
    attr_reader :response, :error_message, :id

    def initialize(response: nil, error_message: nil, id: nil)
      @response = response
      @error_message = error_message
      @id = id
    end

    def self.create(user:, card:)
      response = Stripe::Customer.create(
        email: user.email,
        card: card
      )

      new(response: response, id: response.id)
    rescue Stripe::CardError => e
      body = e.json_body
      error = body.dig(:error, :message)
      new(error_message: error)
    end

    def successful?
      response.present?
    end
  end

  class Subscription
    attr_reader :response, :error_message

    def initialize(response: nil, error_message: nil)
      @response = response
      @error_message = error_message
    end

    def self.create(customer:, plan:)
      if customer.error_message
        new(error_message: customer.error_message)
      else
        create_subscription(customer, plan)
      end
    end

    private_class_method def self.create_subscription(customer, plan)
      response = Stripe::Subscription.create(
        customer: customer.id,
        plan: plan
      )

      new(response: response)
    rescue Stripe::InvalidRequestError => e
      body = e.json_body
      error = body.dig(:error, :message)
      new(error_message: error)
    end

    def successful?
      response.present?
    end
  end
end
