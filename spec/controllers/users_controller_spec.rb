require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new

      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "with valid input" do
      let(:morpheus) { create(:user) }
      let(:invitation) { create(:invitation, inviter: morpheus, recipient_email: "neo@matrix.io") }

      before do
        post :create, user: { email: 'neo@matrix.io', password: "password", full_name: "Thomas Anderson" }, token: invitation.token
      end

      it "creates a user when all the fields are correct" do
        expect(User.count).to eq(2)
      end

      it "redirects to the login path" do
        expect(response).to redirect_to(:login)
      end

      it "sets the success flash" do
        expect(flash[:success]).to be_present
      end

      it "sends out email to the user" do
        expect(ActionMailer::Base.deliveries.last.to).to eq(["neo@matrix.io"])
      end

      it "sends out email containing the users name" do
        expect(ActionMailer::Base.deliveries.last.body).to include("Thomas Anderson")
      end

      it "makes the user follow the inviter" do
        neo = User.find_by(email: "neo@matrix.io")
        expect(neo.follows?(morpheus)).to be_truthy
      end

      it "makes the inviter follow the user" do
        neo = User.find_by(email: "neo@matrix.io")
        expect(morpheus.follows?(neo)).to be_truthy
      end

      it "expires the invitation upon acceptance" do
        expect(invitation.reload.token).to be_nil
      end
    end

    context "User not created with invalid input" do
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

      it "does not send out an email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe "GET show" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :show, id: 1 }
    end

    it "sets @user" do
      set_current_user
      neo = create(:user)

      get :show, id: neo.id

      expect(assigns(:user)).to eq(neo)
    end
  end

  describe "GET #new_with_invitation_token" do
    context "with valid token" do
      let(:invitation) { create(:invitation) }

      before do
        get :new_with_invitation_token, token: invitation.token
      end

      it "sets @user with recipient's email" do
        expect(assigns(:user).email).to eq(invitation.recipient_email)
      end

      it "sets @user with recipient's full_name" do
        expect(assigns(:user).full_name).to eq(invitation.recipient_name)
      end

      it "sets @invitation_token" do
        expect(assigns(:invitation_token)).to eq(invitation.token)
      end

      it "renders the :new view template" do
        expect(response).to render_template :new
      end
    end

    context "with invalid token" do
      it "redirects to the expired token page" do
        get :new_with_invitation_token, token: 'not in database'
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end
