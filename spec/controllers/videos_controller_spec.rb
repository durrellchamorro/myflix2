require 'spec_helper'

describe VideosController do
  describe "GET show" do
    context "with authenticated users" do
      let(:video) { create(:comedy_video) }
      before do
        session[:user_id] = create(:user).id
        get :show, id: video.id
      end

      it "sets @video" do
        expect(assigns(:video)).to eq(video)
      end

      it "sets @reviews" do
        expect(assigns(:reviews)).to eq(Review.where(video: video.id))
      end

      it "renders the show template" do
        expect(response).to render_template(:show)
      end
    end

    context "with unauthenticated users" do
      let(:video) { create(:comedy_video) }
      it "redirects the user to the sign in page" do
        get :show, id: video.id

        expect(response).to redirect_to(:login)
      end
    end

    describe "POST search" do
      context "with authenticated user" do
        let(:video1) { create(:comedy_video, title: "Family Guy") }
        let(:video2) { create(:comedy_video, title: "Star Trek") }
        before do
          session[:user_id] = create(:user).id
        end

        it "sets @videos to the result of Video.search_by_title(params[:search_term])" do
          post :search, search_term: "Family"

          expect(assigns(:videos)).to eq([video1])
        end
      end

      it "redirects to the login page if a user is not authenticated" do
        post :search, search_term: "Family"

        expect(response).to redirect_to(:login)
      end
    end
  end
end
