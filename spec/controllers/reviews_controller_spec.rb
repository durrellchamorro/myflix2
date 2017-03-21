require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    context "with unauthenticated users" do
      it "redirects the user to the sign in page" do
        post :create

        expect(response).to redirect_to(:login)
      end
    end

    context "with authenticated user" do
      let(:user) { create(:user) }
      let(:video) { create(:video) }

      context "with valid form data" do
        before do
          session[:user_id] = user.id
          review = build(:review, user: user, video: video)
          post :create, review.attributes
        end

        it "creates a review" do
          expect(Review.count).to eq(1)
        end

        it "renders the video show page" do
          expect(response).to render_template("videos/show")
        end

        it "sets @video" do
          expect(assigns(:video)).to eq(video)
        end

        it "sets @reviews" do
          expect(assigns(:reviews)).to eq(Review.where(video: video))
        end

        it "sets the success flash" do
          expect(flash[:success]).to be_present
        end
      end

      context "with invalid form data" do
        before do
          session[:user_id] = user.id
          review = build(:review, user: user, video: video, content: nil, rating: nil)
          post :create, review.attributes
        end

        it "sets @video" do
          expect(assigns(:video)).to eq(video)
        end

        it "sets @reviews" do
          expect(assigns(:reviews)).to eq(Review.where(video: video))
        end

        it "sets the danger flash" do
          expect(flash[:danger]).to be_present
        end
        it "renders the video show page" do
          expect(response).to render_template("videos/show")
        end
      end
    end
  end
end
