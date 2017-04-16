require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:token) }
  it { should have_many(:reviews) }
  it { should have_many(:photos) }

  describe 'search_by_title' do
    it 'returns an empty array if no title matches the search query' do
      create(:video, title: "Jurassic Park")
      expect(Video.search_by_title('The Matrix')).to eq([])
    end

    it 'returns a video whose title exactly matches the query' do
      video1 = create(:video, title: 'Edward Scissorhands')
      create(:video)
      create(:video)

      expect(Video.search_by_title('Edward Scissorhands')).to eq([video1])
    end

    it 'returns an array of videos whose title partialy matches the search query ordered by created_at' do
      video1 = create(:video, title: 'Family Guy', created_at: 3.days.ago)
      video2 = create(:video, title: "Mia Familia", created_at: 2.days.ago)
      video3 = create(:video, title: "asdfFamiaaaaa", created_at: 1.day.ago)

      expect(Video.search_by_title('Fami')).to eq([video1, video2, video3])
    end

    it 'returns an array of one video when only one video title matches the query' do
      video1 = create(:video, title: "Family Guy")
      create(:video, title: "The Matrix")
      create(:video, title: "Inception")

      expect(Video.search_by_title('Fami')).to eq([video1])
    end

    it 'returns an empty array for a search with an empty string' do
      create(:video)
      create(:video)

      expect(Video.search_by_title("")).to eq([])
    end

    it 'performs a case insensitive search' do
      video = create(:video, title: "The Matrix")

      expect(Video.search_by_title('matrix')).to eq([video])
    end
  end

  describe "#print_average_video_rating" do
    let(:video) { create(:video) }

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
