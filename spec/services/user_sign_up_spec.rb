require 'spec_helper'

describe UserSignUp do
  describe "#sign_up" do
    context "with an invalid user" do
      let(:user_sign_up) { UserSignUp.new(build(:user, email: ""), nil) }

      before do
        user_sign_up.sign_up("some_token")
      end

      it "does not charge the card" do
        expect(StripeWrapper::Charge).not_to receive(:create)
      end

      it "does not set the failed attribute or the successful attribute" do
        expect(user_sign_up.successful.nil? && user_sign_up.failed.nil?).to be true
      end

      it "does not send out an email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "does not create a user" do
        expect(User.count).to eq(0)
      end
    end

    context "valid user and failed charge" do
      let(:charge) { double(successful?: false, error_message: "That didn't work.") }
      let(:user_sign_up) { UserSignUp.new(build(:user), nil) }

      before do
        allow(StripeWrapper::Charge).to receive(:create).and_return(charge)
        user_sign_up.sign_up("failure_token")
      end

      it "sets @failed to true" do
        expect(user_sign_up.failed).to be_truthy
      end

      it "sets @error_message equal to the error_message on the failed charge" do
        expect(user_sign_up.error_message).to eq(charge.error_message)
      end

      it "does not send out an email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "does not create a user" do
        expect(User.count).to eq(0)
      end
    end

    context "valid user and successful charge" do
      let(:neo) { build(:user, full_name: "Thomas Anderson", email: "neo@matrix.io") }
      let(:morpheus) { create(:user)}
      let(:invitation) { create(:invitation, inviter: morpheus, recipient_name: "Thomas Anderson", recipient_email: "neo@matrix.io") }

      before do
        charge = double(successful?: true)
        allow(StripeWrapper::Charge).to receive(:create).and_return(charge)
      end

      it "saves the user" do
        user_sign_up = UserSignUp.new(neo, nil)
        user_sign_up.sign_up("success_token")

        expect(User.count).to eq(1)
      end

      it "makes the inviter and follower follow eachother if an invitation exists" do
        user_sign_up = UserSignUp.new(neo, invitation)
        user_sign_up.sign_up("success_token")

        expect(neo.follows?(morpheus.id) && morpheus.follows?(neo.id)).to be_truthy
      end

      it "does not make the user follow anyone if an invitation does not exist" do
        user_sign_up = UserSignUp.new(neo, nil)
        user_sign_up.sign_up("success_token")

        expect(neo.follows?(morpheus.id)).to be_falsey
        expect(morpheus.follows?(neo.id)).to be_falsey
      end

      it "deletes the token from the invitation" do
        user_sign_up = UserSignUp.new(neo, invitation)
        user_sign_up.sign_up("success_token")

        expect(invitation.token).to be_nil
      end

      it "sends a welcome email to the user" do
        user_sign_up = UserSignUp.new(neo, nil)
        user_sign_up.sign_up("success_token")

        expect(ActionMailer::Base.deliveries.last.to).to eq(["neo@matrix.io"])
      end

      it "sends out email containing the users name" do
        user_sign_up = UserSignUp.new(neo, nil)
        user_sign_up.sign_up("success_token")

        expect(ActionMailer::Base.deliveries.last.body).to include("Thomas Anderson")
      end

      it "sets @successful to true" do
        user_sign_up = UserSignUp.new(neo, nil)
        user_sign_up.sign_up("success_token")

        expect(user_sign_up.successful).to be_truthy
      end
    end
  end
end
