require 'spec_helper'

describe VideosController do
  describe "GET show" do
    context "with authenticated users" do
      let(:video) { create(:comedy_video) }

      before do
        set_current_user
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

    it_behaves_like "require_sign_in" do
      video = FactoryGirl.create(:comedy_video)
      let(:action) { get :show, id: video.id }
    end


    describe "POST search" do
      context "with authenticated user" do
        let(:video1) { create(:comedy_video, title: "Family Guy") }
        let(:video2) { create(:comedy_video, title: "Star Trek") }

        before do
          set_current_user
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
