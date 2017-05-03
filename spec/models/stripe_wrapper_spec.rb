require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      it "makes a successful charge", :vcr do
        charge = StripeWrapper::Charge.create(
          amount: 999,
          source: "tok_visa",
          description: "A valid charge"
        )

        expect(charge.successful?).to be true
      end

      it "makes an unsuccessful charge due to a declined card", :vcr do
        charge = StripeWrapper::Charge.create(
          amount: 999,
          source: "tok_chargeDeclined",
          description: "An invalid charge"
        )

        expect(charge.successful?).not_to be true
      end

      it "returns the error message for declined charges", :vcr do
        charge = StripeWrapper::Charge.create(
          amount: 999,
          source: "tok_chargeDeclined",
          description: "An invalid charge"
        )

        expect(charge.error_message).to eq("Your card was declined.")
      end
    end
  end
end
