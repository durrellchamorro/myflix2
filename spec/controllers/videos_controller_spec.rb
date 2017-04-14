require 'spec_helper'

describe VideosController do
  describe "GET show" do
    context "with authenticated users" do
      let(:video) { create(:video) }

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
      video = FactoryGirl.create(:video)
      let(:action) { get :show, id: video.id }
    end


    describe "POST search" do
      context "with authenticated user" do
        let(:video1) { create(:video, title: "Family Guy") }
        let(:video2) { create(:video, title: "Star Trek") }

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

    describe "GET index" do
      context "with authenticated user" do
        before do
          set_current_user
        end

        it "sets @categories" do
          get :index
          expect(assigns(:categories)).to be_a(Array)
        end

        it "sets @categories equal only to categories with videos associated" do
          action = create(:category)
          create(:category)
          create(:video, category: action)

          get :index

          expect(assigns(:categories)).to match_array([action])
        end
      end

      context "with unauthenticated user" do
        it_behaves_like "require_sign_in" do
          let(:action) { get :index }
        end
      end
    end
  end
end
