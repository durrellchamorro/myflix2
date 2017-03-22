require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets @queue_items to the queue items of the current user" do
      alice = create(:user)
      session[:user_id] = alice.id
      queue_item1 = create(:queue_item, user: alice, position: 1)
      queue_item2 = create(:queue_item, user: alice, position: 2)

      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it "redirects to the sign in page for unauthenticated users" do
      get :index
      expect(response).to redirect_to(:login)
    end
  end

  describe "POST create" do
    context "with authenticated user" do
      let(:video) { create(:video) }
      let(:current_user) { User.find(session[:user_id]) }
      before do
        session[:user_id] = create(:user).id
        post :create, video_id: video.id
      end

      it "redirects to the my queue page" do
        expect(response).to redirect_to(my_queue_path)
      end

      it "creates a queue item" do
        expect(QueueItem.count).to eq(1)
      end

      it "creates the queue item that is associated with the video" do
        expect(QueueItem.first.video).to eq(video)
      end

      it "creates the queue item that is associated with the signed in user" do
        expect(QueueItem.first.user.id).to eq(session[:user_id])
      end

      it "puts the video as the last one in the queue" do
        matrix = create(:video)
        post :create, video_id: matrix.id
        matrix_queue_item = QueueItem.where(user: current_user, video: matrix).first
        video_queue_item = QueueItem.where(user: current_user, video: video).first

        expect(matrix_queue_item.position).to eq(2)
        expect(video_queue_item.position).to eq(1)
      end

      it "does not add the video to the queue if the video is already in the queue" do
        post :create, video_id: video.id

        expect(current_user.queue_items.count).to eq(1)
      end
    end

    context "with unauthenticated user" do
      it "redirects to the sign in page for unauthenticated users" do
        post :create, video_id: create(:video).id
        expect(response).to redirect_to(:login)
      end
    end
  end
end
