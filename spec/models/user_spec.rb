require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password_digest) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:reviews) }
  it { should have_many(:queue_items).order(:position) }

  describe '#video_review' do
    let(:neo) { create(:user) }
    let(:video) { create(:video) }

    it "returns the current users review for the video" do
      review = create(:review, user: neo, video: video, rating: 5)

      expect(neo.video_review(video)).to eq(5)
    end
    it "returns nill if the current user has not reviewed the video" do
      expect(neo.video_review(video)).to eq(nil)
    end
  end
end
