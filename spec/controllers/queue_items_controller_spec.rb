require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets @queue_items to the queue items of the current user" do
      set_current_user
      alice = current_user
      queue_item1 = create(:queue_item, user: alice, position: 1)
      queue_item2 = create(:queue_item, user: alice, position: 2)

      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :index}
    end
  end

  describe "POST create" do
    context "with authenticated user" do
      let(:video) { create(:video) }

      before do
        set_current_user
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

    it_behaves_like "require_sign_in" do
      let(:action) { post :create, video_id: create(:video).id }
    end
  end

  describe "DELETE destroy" do
    context "with authenticated user" do
      let!(:queue_item1) { create(:queue_item, user: neo, position: 2) }
      let!(:queue_item2) { create(:queue_item, user: neo, position: 3) }
      let!(:queue_item3) { create(:queue_item, user: neo, position: 6) }
      let(:neo) { create(:user) }

      before do
        set_current_user(neo)
        delete :destroy, id: queue_item2.id
      end

      it "redirects to the my queue page" do
        expect(response).to redirect_to(my_queue_path)
      end

      it "deletes the queue item" do
        expect(QueueItem.count).to eq(2)
      end

      it "does not delete the queue item if the current user does not own the queue item" do
        other_user = create(:user)
        other_users_queue_item = create(:queue_item, user: other_user)
        delete :destroy, id: other_users_queue_item.id

        expect(QueueItem.find(other_users_queue_item.id)).to be_present
      end

      it "normalizes the remaining queue items" do
        expect(queue_item1.reload.position).to eq(1)
        expect(queue_item3.reload.position).to eq(2)
      end
    end

    it_behaves_like "require_sign_in" do
      let(:action) { delete :destroy, id: 1 }
    end
  end

  describe "POST update_queue" do
    context "with valid inputs" do
      let(:neo) { create(:user) }
      let(:queue_item1) { create(:queue_item, user: neo, position: 1) }
      let(:queue_item2) { create(:queue_item, user: neo, position: 2) }

      before do
        set_current_user(neo)
      end

      it "redirects to the my queue page" do
        post :update_queue, queue_items: [{ id: queue_item1.id, position: 1 }, { id: queue_item2.id, position: 2 }]
        expect(response).to redirect_to(my_queue_path)
      end

      it "reorders the queue items" do
        post :update_queue, queue_items: [{ id: queue_item1.id, position: 2 }, { id: queue_item2.id, position: 1 }]

        expect(queue_item1.reload.position).to eq(2)
        expect(queue_item2.reload.position).to eq(1)
      end

      it "normalizes the position numbers" do
        post :update_queue, queue_items: [{ id: queue_item1.id, position: 5 }, { id: queue_item2.id, position: 4 }]

        expect(queue_item1.reload.position).to eq(2)
        expect(queue_item2.reload.position).to eq(1)
      end
    end

    context "with invalid inputs" do
      let(:neo) { create(:user) }
      let(:queue_item1) { create(:queue_item, user: neo, position: 3) }
      let(:queue_item2) { create(:queue_item, user: neo, position: 4) }

      before do
        set_current_user(neo)
        post :update_queue, queue_items: [{ id: queue_item1.id, position: 1 }, { id: queue_item2.id, position: 2.5 }]
      end

      it "redirects to the my queue page" do
        expect(response).to redirect_to my_queue_path
      end

      it "sets the flash error message" do
        expect(flash[:danger]).to be_present
      end

      it "does not change the queue items" do
        expect(queue_item1.reload.position).to eq(3)
      end
    end

    context "with unauthenticated user" do
      let(:queue_item1) { create(:queue_item) }
      let(:queue_item2) { create(:queue_item) }

      it_behaves_like "require_sign_in" do
        let(:action) { post :update_queue, queue_items: [{ id: queue_item1.id, position: 5 }, { id: queue_item2.id, position: 4 }] }
      end
    end

    context "with queue items that don't belong to the current user" do
      let(:neo) { create(:user) }
      let(:queue_item1) { create(:queue_item, user: neo, position: 3) }
      let(:queue_item2) { create(:queue_item, user: neo, position: 4) }
      let(:morpheus) { create(:user) }

      it "does not change the queue items" do
        set_current_user(morpheus)
        post :update_queue, queue_items: [{ id: queue_item1.id, position: 1 }, { id: queue_item2.id, position: 2 }]

        expect(queue_item1.reload.position).to eq(3)
        expect(queue_item2.reload.position).to eq(4)
      end
    end
  end
end
