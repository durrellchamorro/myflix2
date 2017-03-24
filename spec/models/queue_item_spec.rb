require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_numericality_of(:position).only_integer }

  let(:video) { create(:video) }
  let(:queue_item) { create(:queue_item, video: video) }

  describe "#video_title" do
    it "returns the title of the associated video" do
      video.title = "Matrix"

      expect(queue_item.video_title).to eq('Matrix')
    end
  end

  describe "#rating" do
    it "returns the users rating of the associated video when rating is present" do
      neo = create(:user)
      queue_item.user = neo

      create(:review, video: video, rating: 1, user: neo)
      create(:review, video: video, rating: 2)

      expect(queue_item.rating).to eq(1)
    end
    it "return nil when the associated video doesn't have a rating" do
      expect(queue_item.rating).to eq(nil)
    end
  end

  describe "#category_name" do
    it "returns the cateogry name of the associated video" do
      expect(queue_item.category_name).to eq(video.category.name)
    end
  end

  describe "#category" do
    it "returns the category object of the associated video" do
      expect(queue_item.category).to eq(video.category)
    end
  end

  describe '#rating=' do
    it "changes the rating of the review if the review is present" do
      video = create(:video)
      neo = create(:user)
      create(:review, video: video, rating: 4, user: neo)
      queue_item = create(:queue_item, user: neo, video: video)

      queue_item.rating = 1

      expect(queue_item.rating).to eq(1)
    end

    it "clears the rating of the review if the review is present" do
      video = create(:video)
      neo = create(:user)
      create(:review, video: video, rating: 4, user: neo)
      queue_item = create(:queue_item, user: neo, video: video)

      queue_item.rating = nil

      expect(queue_item.rating).to be_nil
    end

    it "creates a review with the rating if the review is not present" do
      video = create(:video)
      neo = create(:user)
      queue_item = create(:queue_item, user: neo, video: video)

      queue_item.rating = 5

      expect(queue_item.rating).to eq(5)
    end
  end
end
