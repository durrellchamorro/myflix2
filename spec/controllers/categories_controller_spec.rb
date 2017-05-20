require 'spec_helper'

describe CategoriesController do
  describe "GET show" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :show, id: 1}
    end

    it "sets @category" do
      set_current_user
      comedies = create(:category)
      get :show, id: comedies.id

      expect(assigns(:category)).to eq(comedies)
    end

    it "sets @videos" do
      set_current_user
      action = create(:category)
      the_matrix = create(:video, category: action)
      get :show, id: action.id

      expect(assigns(:videos)).to eq([the_matrix])
    end
  end
end
