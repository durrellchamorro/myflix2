module StripeWrapper
  class Charge
    attr_reader :error_message, :response

    def initialize(response: nil, error_message: nil)
      @response = response
      @error_message = error_message
    end

    def self.create(amount:, source:, description:)
      begin
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
    end

    def successful?
      response.present?
    end
  end
end
