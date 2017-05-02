require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      it "makes a successful charge", :vcr do
        response = StripeWrapper::Charge.create(
          amount: 999,
          source: "tok_visa",
          description: "A valid charge"
        )

        expect(response.successful?).to be true
      end

      it "makes an unsuccessful charge due to a declined card", :vcr do
        response = StripeWrapper::Charge.create(
          amount: 999,
          source: "tok_chargeDeclined",
          description: "An invalid charge"
        )

        expect(response.successful?).not_to be true
      end

      it "returns the error message for declined charges", :vcr do
        response = StripeWrapper::Charge.create(
          amount: 999,
          source: "tok_chargeDeclined",
          description: "An invalid charge"
        )

        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end
end
