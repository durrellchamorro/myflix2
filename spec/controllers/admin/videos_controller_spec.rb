require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "require_admin" do
      let(:action) { post :create }
    end

    it "sets the @video to a new video" do
      set_current_admin(create(:user))
      get :new

      expect(assigns(:video)).to be_a_new(Video)
    end
  end

  describe "POST create" do
    it_behaves_like "require_admin" do
      let(:action) { post :create }
    end

    context "with valid input" do
      before do
        set_current_admin
        post :create, params: { video: attributes_for(:video), photo: attributes_for(:photo) }, format: :js
      end

      it "renders the new template" do
        expect(response).to render_template :new
      end

      it "creates a video" do
        expect(Video.count).to eq(1)
      end

      it "sets the success flash" do
        expect(flash[:success]).to be_present
      end

      it "sets @video to a new instance of Video" do
        expect(assigns(:video)).to be_a_new(Video)
      end

      it "creates a Photo" do
        expect(Photo.count).to eq(1)
      end
    end

    context "with a photo but invalid input" do
      before do
        set_current_admin
        post :create, params: { video: { title: "", description: "", category_id: "" }, photo: attributes_for(:photo) }, format: :js
      end

      it "does not create a video" do
        expect(Video.count).to be(0)
      end

      it "does not create a photo" do
        expect(Photo.count).to eq(0)
      end

      it "renders the :new template" do
        expect(response).to render_template :new
      end

      it "sets @video" do
        expect(assigns(:video)).to be_a_new(Video)
      end

      it "sets the flass danger message" do
        expect(flash[:danger]).to be_present
      end
    end

    context "with valid input but no photo" do
      before do
        set_current_admin
        post :create, params: { video: attributes_for(:video).merge(category_id: 1) }, format: :js
      end

      it "does not create a video" do
        expect(Video.count).to eq(0)
      end

      it "does not create a photo" do
        expect(Photo.count).to eq(0)
      end

      it "renders the :new template" do
        expect(response).to render_template :new
      end

      it "sets @video" do
        expect(assigns(:video)).to be_a_new(Video)
      end

      it "sets the flass danger message" do
        expect(flash[:danger]).to be_present
      end
    end
  end
end
