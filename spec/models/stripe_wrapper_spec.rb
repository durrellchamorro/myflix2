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

  describe StripeWrapper::Customer do
    describe ".create" do
      let(:neo) { create(:user) }

      context "with a valid card", :vcr do
        let(:customer) { StripeWrapper::Customer.create(user: neo, card: "tok_visa") }

        it "creates a customer" do
          expect(customer.successful?).to be true
        end

        it "sets the id" do
          expect(customer.id).to be_present
        end
      end

      context "with a declined card", :vcr do
        let(:customer) { StripeWrapper::Customer.create(user: neo, card: "tok_chargeDeclined") }

        it "does not create a customer" do
          expect(customer.successful?).to be false
        end

        it "does not set the id" do
          expect(customer.id).not_to be_present
        end

        it "returns the error message" do
          expect(customer.error_message).to eq("Your card was declined.")
        end
      end
    end
  end

  describe StripeWrapper::Subscription do
    describe ".create" do
      let(:neo) { create(:user) }

      context "with a valid plan and a valid customer", :vcr do
        it "creates a subscription" do
          customer = StripeWrapper::Customer.create(user: neo, card: "tok_visa")
          subscription = StripeWrapper::Subscription.create(
            customer: customer,
            plan: "basic_plan_id"
          )

          expect(subscription.successful?).to be true
        end
      end

      context "with a valid plan and an invalid customer", :vcr do
        let(:customer) do
          StripeWrapper::Customer.create(user: neo, card: "tok_chargeDeclined")
        end

        let(:subscription) do
          StripeWrapper::Subscription.create(customer: customer,
                                             plan: "basic_plan_id")
        end

        it "does not create a subscription" do
          expect(subscription.successful?).to be false
        end

        it "returns the correct error message" do
          expect(subscription.error_message).to eq("Your card was declined.")
        end
      end

      context "with a valid customer and an ivalid plan", :vcr do
        let(:customer) do
          StripeWrapper::Customer.create(user: neo, card: "tok_visa")
        end

        let(:subscription) do
          StripeWrapper::Subscription.create(customer: customer,
                                             plan: "invalid_plan_name")
        end

        it "does not create a subscription" do
          expect(subscription.successful?).to be false
        end

        it "returns the correct error message" do
          expect(subscription.error_message).to eq("No such plan: invalid_plan_name")
        end
      end
    end

    describe ".cancel" do
      it "sends the correct messages to Stripe" do
        myflix_database_subscription = create(:subscription)
        stripe_database_subscription = double
        allow(stripe_database_subscription).to receive(:delete)
        allow(Stripe::Subscription).to receive(:retrieve).and_return(stripe_database_subscription)

        StripeWrapper::Subscription.cancel(myflix_database_subscription)

        expect(stripe_database_subscription).to have_received(:delete).with(at_period_end: true)
      end
    end
  end
end
