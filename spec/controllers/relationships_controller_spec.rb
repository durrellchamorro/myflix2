require 'spec_helper'

describe RelationshipsController do
  describe "GET index" do
    it "sets @relationships to the current user's following relationships" do
      neo = create(:user)
      set_current_user(neo)
      morpheus = create(:user)
      relationship = create(:relationship, follower: neo, leader: morpheus)

      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :index }
    end
  end

  describe "DELETE destroy" do
    let(:neo) { create(:user) }
    let(:morpheus) { create(:user) }

    before do
      set_current_user(neo)
    end

    it_behaves_like "require_sign_in" do
      let(:action) { delete :destroy, id: 1 }
    end

    it "deletes the relationship if the current user is the follower" do
      relationship = create(:relationship, leader: morpheus, follower: neo)

      delete :destroy, id: relationship.id

      expect(Relationship.count).to eq(0)
    end

    it "does not delete the relationship if the current user is not the follower" do
      relationship = create(:relationship, leader: neo, follower: morpheus)

      delete :destroy, id: relationship.id

      expect(Relationship.count).to eq(1)
    end

    it "redirects to the people page" do
      delete :destroy, id: 1

      expect(response).to redirect_to people_path
    end

    it "sets the success flash if the relationship was deleted" do
      relationship = create(:relationship, leader: morpheus, follower: neo)

      delete :destroy, id: relationship.id

      expect(flash[:success]).to be_present
    end
    it "sets the danger flash if the relationship was not deleted" do
      relationship = create(:relationship, leader: neo, follower: morpheus)

      delete :destroy, id: relationship.id

      expect(flash[:danger]).to be_present
    end
  end
end
