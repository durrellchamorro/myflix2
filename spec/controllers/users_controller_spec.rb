require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new

      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "with valid personal info and valid card info" do
      before do
        user_sign_up = double(successful: true)
        expect(UserSignUp).to receive(:new).and_return(user_sign_up)
        expect(user_sign_up).to receive(:sign_up)

        post :create, user: { email: "", password: "", full_name: "" }, token: "", stripeToken: ""
      end

      it "assigns @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "redirects to the login path" do
        expect(response).to redirect_to(:login)
      end

      it "sets the success flash" do
        expect(flash[:success]).to be_present
      end
    end

    context "valid personal info and declined card" do
      before do
        user_sign_up = double(failed: true, successful: nil, error_message: "Failed")
        expect(UserSignUp).to receive(:new).and_return(user_sign_up)
        expect(user_sign_up).to receive(:sign_up)
        post :create, user: { email: '', password: "", full_name: "" }, stripeToken: ""
      end

      it "assigns @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end

      it "sets the flash error message" do
        expect(flash[:danger]).to be_present
      end
    end

    context "with invalid personal info" do
      before do
        user_sign_up = double(failed: nil, successful: nil)
        expect(UserSignUp).to receive(:new).and_return(user_sign_up)
        expect(user_sign_up).to receive(:sign_up)
        post :create, user: { email: "" }
      end

      it "renders the new template" do
        expect(response).to render_template(:new)
      end

      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)
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
