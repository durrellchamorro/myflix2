require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with blank input" do
      it "redirects to the forgot password page" do
        post :create, email: ''
        expect(response).to redirect_to forgot_password_path
      end

      it "shows an error message" do
        post :create, email: ''
        expect(flash[:danger]).to eq("Email cannot be blank.")
      end

    end

    context "with existing email" do
      let!(:neo) { create(:user, email: "neo@matrix.com") }
      before { post :create, email: "neo@matrix.com" }

      it "redirects to the forgot password confirmation page" do
        expect(response).to redirect_to forgot_password_confirmation_path
      end

      it "sends out an email to the email address" do
        expect(ActionMailer::Base.deliveries.last.to).to eq(["neo@matrix.com"])
      end

      it "generates a user token" do
        expect(neo.reload.token).to be_present
      end
    end

    context "with non-existing email" do
      before { post :create, email: 'foo@example.com' }

      it "redirects to the forgot password page" do
        expect(response).to redirect_to forgot_password_path
      end

      it "shows an error message" do
        expect(flash[:danger]).to eq("There is no user with that email in the system.")
      end
    end
  end
end
