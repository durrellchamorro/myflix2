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
    it "returns the average rating of the associated video when rating is present" do
      create(:review, video: video, rating: 1)
      create(:review, video: video, rating: 2)

      expect(queue_item.rating).to eq(1.5)
    end
    it "return N/A when the associated video doesn't have a rating" do
      expect(queue_item.rating).to eq("N/A")
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
end
