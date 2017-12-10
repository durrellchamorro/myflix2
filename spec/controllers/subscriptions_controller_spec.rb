require 'spec_helper'

describe SubscriptionsController do
  describe "DELETE destroy" do
    context "with signed in user" do
      let(:subscription) { double }

      before do
        set_current_user
      end

      it "sends the cancel message to StripeWrapper::Subscription" do
        expect(Subscription).to receive(:find).with("2").and_return(subscription)
        expect(StripeWrapper::Subscription).to receive(:cancel).with(subscription)

        post :destroy, params: { _method: "delete", id: "2" }
      end

      it "sets the flash success message" do
        allow(Subscription).to receive(:find)
        allow(StripeWrapper::Subscription).to receive(:cancel)

        post :destroy, params: { _method: "delete", id: "2" }

        expect(flash[:success]).to be_present
      end

      it "redirects to the home path" do
        allow(Subscription).to receive(:find)
        allow(StripeWrapper::Subscription).to receive(:cancel)

        post :destroy, params: { _method: "delete", id: "2" }

        expect(response).to redirect_to home_path
      end
    end

    context "without a user signed in" do
      it "redirects to the login path" do
        allow(Subscription).to receive(:find)
        allow(StripeWrapper::Subscription).to receive(:cancel)

        post :destroy, params: { _method: "delete", id: "2" }

        expect(response).to redirect_to login_path
      end

      it "sets the danger flash" do
        allow(Subscription).to receive(:find)
        allow(StripeWrapper::Subscription).to receive(:cancel)

        post :destroy, params: { _method: "delete", id: "2" }

        expect(flash[:danger]).to be_present
      end
    end
  end
end
