require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "redirects to home_path if current_user" do
      set_current_user
      get :new

      expect(response).to redirect_to(home_path)
    end

    it "renders the new template if not current_user" do
      get :new

      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    before do
      post :create, email: user.email, password: user.password
    end

    context "user authenticates" do
      let(:user) { create(:user) }

      it "sets the session user_id" do
        expect(session[:user_id]).to eq(user.id)
      end

      it "sets the flash" do
        expect(flash[:success]).to be_present
      end

      it "redirects to the home path" do
        expect(response).to redirect_to(home_path)
      end
    end

    context "user does not authenticate" do
      let(:user) { User.new }

      it "sets the danger flash" do
        expect(flash[:danger]).to be_present
      end

      it "redirects to the login_path" do
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "GET destroy", :js do
    before do
      set_current_user
      xhr :get, :destroy
    end

    it "sets the user_id session to nil" do
      expect(session[:user_id]).to be_nil
    end

    it "sets the success flash" do
      expect(flash[:success]).to be_present
    end

    it "redirects to the root path" do
      expect(response).to render_template "sessions/destroy"
    end
  end
end
