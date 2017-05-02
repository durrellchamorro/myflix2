module StripeWrapper
  class Charge
    attr_reader :error_message, :response

    def initialize(response: nil, error_message: nil)
      @response = response
      @error_message = error_message
    end

    def self.create(options = {})
      begin
        response = Stripe::Charge.create(
          amount: options[:amount],
          currency: 'usd',
          source: options[:source],
          description: options[:description]
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
