require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password_digest) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:reviews).order("created_at DESC") }
  it { should have_many(:queue_items).order(:position) }
  it { should have_many(:payments) }

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

  describe "#queued_video?" do
    let(:video) { create(:video) }
    let(:neo) { create(:user) }

    it "returns true if the user queued the video" do
      create(:queue_item, video: video, user: neo)

      expect(neo.queued_video?(video)).to be_truthy
    end

    it "returns false if the user did not queue the video" do
      expect(neo.queued_video?(video)).to be_falsey
    end
  end

  describe "#leading_relationships" do
    let(:neo) { create(:user) }
    let(:morpheus) { create(:user) }
    let(:trinity) { create(:user) }

    it "returns more than one relationship when the user is the leader of more than one relationship" do
      relationship1 = create(:relationship, leader: neo, follower: morpheus)
      relationship2 = create(:relationship, leader: neo, follower: trinity)

      expect(neo.leading_relationships).to match_array([relationship1, relationship2])
    end

    it "returns and empty array when there are no relationships where the user is a leader" do
      expect(neo.leading_relationships).to match_array([])
    end

    it "returns one relationship when there is one relationship where the user is the leader" do
      relationship1 = create(:relationship, leader: neo, follower: morpheus)

      expect(neo.leading_relationships).to match_array([relationship1])
    end
  end

  describe "#can_follow?" do
    let(:neo) { create(:user) }
    let(:morpheus) { create(:user) }

    it "returns false if leader_id is the user id" do
      expect(neo.can_follow?(neo.id)).to be_falsey
    end

    it "returns false if the user already following the leader" do
      create(:relationship, leader: neo, follower: morpheus)

      expect(morpheus.can_follow?(neo.id)).to be_falsey
    end

    it "returns true if the leader_id is not the same as the user id and the user is not folloing the leader" do
      expect(neo.can_follow?(morpheus.id)).to be_truthy
    end
  end

  describe "#follow" do
    let(:morpheus) { create(:user) }
    let(:neo) { create(:user) }

    it "makes the user follow the leader" do
      morpheus.follow(neo)

      expect(morpheus.follows?(neo)).to be_truthy
    end

    it "doesn't allow the user to follow himself" do
      neo.follow(neo)

      expect(neo.follows?(neo)).to be_falsey
    end

    it "doesn't make the user follow the leader if the user is already following the leader" do
      create(:relationship, leader: neo, follower: morpheus)
      morpheus.follow(neo)

      expect(Relationship.count).to eq(1)
    end
  end
end
