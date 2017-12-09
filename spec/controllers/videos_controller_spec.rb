require 'spec_helper'

describe VideosController do
  describe "GET show" do
    context "with authenticated users" do
      let(:video) { create(:video) }

      before do
        set_current_user
        get :show, params: { id: video.id }
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
      video = FactoryBot.create(:video)
      let(:action) { get :show, params: { id: video.id } }
    end


    describe "POST search", :search do
      context "with authenticated user" do
        let!(:video1) { create(:video, :reindex, title: "Star Wars: Episode 1") }
        let!(:video2) { create(:video, :reindex, title: "Matrix", description: "sun is a star") }
        let!(:star_wars2) { create(:video, :reindex, title: "Star Wars: Episode 2") }
        let!(:bride_wars) { create(:video, :reindex, title: "Bride Wars") }
        let!(:star_trek) { create(:video, :reindex, title: "Star Trek") }

        before do
          set_current_user
        end

        it "assigns @videos to searchkick results based on title and description match" do
          get :search, params: { search_term: "star" }

          expect(assigns(:videos)).to match_array([video1, video2, star_wars2, star_trek])
        end

        it "sets @videos equal to all the videos in the database when the search term is an empty string" do
          get :search, params: { search_term: "" }

          expect(assigns(:videos)).to match_array([video1, video2, star_wars2, bride_wars, star_trek])
        end

        it "follows the default setting which is results must match all words in the query" do
          get :search, params: { search_term: "Star Wars" }

          expect(assigns(:videos)).to match_array([video1, star_wars2])
        end

        it "matches the word start" do
          get :search, params: { search_term: "str" }

          expect(assigns(:videos)).to match_array([video1, video2, star_wars2, star_trek])
        end
      end

      it "redirects to the login page if a user is not authenticated" do
        post :search, params: { search_term: "Star Wars" }

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
          expect(assigns(:categories)).to be_a(ActiveRecord::Relation)
        end

        it "sets @categories equal only to categories with videos associated" do
          action = create(:category)
          create(:category)
          create(:video, category: action)

          get :index

          expect(assigns(:categories)).to match_array([action])
        end

        it "orders the categories alphabetically" do
          scifi = create(:category, name: "Sci-Fi")
          create(:video, category: scifi)
          action = create(:category, name: "Action")
          create(:video, category: action)
          zebra = create(:category, name: "Zebra")
          create(:video, category: zebra)
          comedy = create(:category, name: "Comedy")
          create(:video, category: comedy)

          get :index

          expect(assigns(:categories)).to eq([action, comedy, scifi, zebra])
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
