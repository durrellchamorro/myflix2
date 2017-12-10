require 'spec_helper'

describe PasswordResetsController do
  describe "GET show" do
    before { create(:user, token: '12345') }

    it "renders the show template if the token is valid" do
      get :show, params: { token: '12345' }

      expect(response).to render_template :show
    end

    it "redirects to the expired token page if the token is not valid" do
      get :show, params: { token: 'a token that does not in the database' }
      expect(response).to redirect_to expired_token_path
    end

    it "sets @token" do
      get :show, params: { token: '12345' }
      expect(assigns(:token)).to eq("12345")
    end
  end

  describe "POST create" do
    context "with valid token" do
      let!(:neo) { create(:user, token: "12345", password: 'old_password') }
      before { post :create, params: { token: '12345', password: 'new_password' } }

      it "updates the user's password" do
        expect(neo.reload.authenticate('new_password')).to be_truthy
      end

      it "redirects to the sign in page" do
        expect(response).to redirect_to(:login)
      end

      it "sets the flash success message" do
        expect(flash[:success]).to be_present
      end

      it "deletes the users token" do
        expect(neo.reload.token.present?).to be_falsey
      end
    end

    context "with invalid token" do
      it "redirects to the expired token path" do
        post :create, params: { token: 'not in database', password: 'new_password' }

        expect(response).to redirect_to expired_token_path
      end
    end
  end
end
