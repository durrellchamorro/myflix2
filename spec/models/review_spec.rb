require 'spec_helper'

describe Review do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:rating) }
  it { should validate_presence_of(:video_id) }

  describe "validation error" do
    let(:neo) { create(:user) }
    let(:video) { create(:video) }

    it "raises an error if the user has already reviewd the video" do
      create(:review, video: video, user: neo)
      second_review = build(:review, video: video, user: neo)

      expect(second_review.valid?).to be_falsey
    end

    it "does not raise an error if the user has not reviewed the video yet" do
      first_review = build(:review, video: video, user: neo)

      expect(first_review.valid?).to be_truthy
    end
  end

  describe "valid_reviews" do
    let(:video) { create(:video) }

    it "returns one review when there is one review with a rating >= 1" do
      review1 = create(:review, rating: 1, video: video)
      review2 = create(:review, rating: 0, video: video)

      expect(Review.valid_reviews(video)).to match_array([review1])
    end

    it "returns an empty array when there are no reviews with a rating >= 1" do
      review = create(:review, rating: 0, video: video)

      expect(Review.valid_reviews(video)).to match_array([])
    end

    it "returns many reviews when there are many reviews with a rating >= 1" do
      review1 = create(:review, rating: 1, video: video)
      review2 = create(:review, rating: 2, video: video)

      expect(Review.valid_reviews(video)).to match_array([review1, review2])
    end

    it "returns an empty array when a rating is nil" do
      review = build(:review, rating: nil, video: video)

      review.save(validate: false)

      expect(Review.valid_reviews(video)).to match_array([])
    end
  end
end
