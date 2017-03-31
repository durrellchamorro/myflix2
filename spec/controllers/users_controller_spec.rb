require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new

      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "User created successfully with valid input" do
      before do
        post :create, user: attributes_for(:user, full_name: "Thomas Anderson", email: "neo@matrix.io")
      end

      after { ActionMailer::Base.deliveries.clear }

      it "creates a user when all the fields are correct" do
        expect(User.all.size).to eq(1)
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
    end

    context "User not created with invalid input" do
      before do
        post :create, user: { email: "" }
      end

      after { ActionMailer::Base.deliveries.clear }

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
end
