require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new

      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "User created successfully" do
      before do
        post :create, user: attributes_for(:user)
      end

      it "creates a user when all the fields are correct" do
        expect(User.all.size).to eq(1)
      end

      it "redirects to the login path" do
        expect(response).to redirect_to(:login)
      end

      it "sets the success flash" do
        expect(flash[:success]).to be_present
      end
    end

    context "User not created" do
      before do
        post :create, user: { email: "" }
      end

      it "does not create a user when not enough information given" do
        expect(User.count).to eq(0)
      end

      it "renders the new template" do
        expect(response).to render_template(:new)
      end
      
      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
  end
end
