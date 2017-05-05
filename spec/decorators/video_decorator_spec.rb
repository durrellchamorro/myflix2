require 'spec_helper'

describe VideoDecorator do
  describe "#print_average_video_rating" do
    let(:video) { create(:video).decorate }

    it "retuns nil when there are no ratings" do
      expect(video.print_average_video_rating).to eq(nil)
    end

    it "returns the rating when there is one rating" do
      create(:review, rating: 1, video: video)
      expect(video.print_average_video_rating).to eq(1)
    end

    it "retuns the aveage rating when there are more than one rating" do
      create(:review, rating: 1, video: video)
      create(:review, rating: 2, video: video)

      expect(video.print_average_video_rating).to eq(1.5)
    end

    it "rounds the rating to two decimal places" do
      create(:review, rating: 1, video: video)
      create(:review, rating: 1, video: video)
      create(:review, rating: 3, video: video)

      expect(video.print_average_video_rating).to eq(1.67)
    end

    it "doesn't calculate nil ratings" do
      create(:review, rating: 1, video: video)
      review = build(:review, rating: nil, video: video)
      review.save(validate: false)

      expect(video.print_average_video_rating).to eq(1)
    end

    it "doesn't calculate 0 ratings" do
      create(:review, rating: 1, video: video)
      review = build(:review, rating: 0, video: video)
      review.save(validate: false)

      expect(video.print_average_video_rating).to eq(1)
    end

    it "returns nil when there aren't any accepted reviews" do
      expect(video.print_average_video_rating).to eq(nil)
    end
  end
end
