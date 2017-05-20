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

  describe ".set_advanced_search_options" do
    it "only sets the review option when only the review option is given" do
      Video.set_advanced_search_options("", "", "y", "1")
      expected_result = {
        fields: [{ title: :word_start }, "description^50", "title^100", :reviews],
        where: { average_rating: {} },
        page: "1",
        per_page: 20
      }

      expect(Video.instance_variable_get(:@advanced_search_options)).to eq(expected_result)
    end

    it "only sets the rating_from option when only the rating_from option is given" do
      Video.set_advanced_search_options("1", "", "", "1")
      expected_result = {
        fields: [{ title: :word_start }, "description^50", "title^100"],
        where: { average_rating: { gte: "1" } },
        page: "1",
        per_page: 20
      }

      expect(Video.instance_variable_get(:@advanced_search_options)).to eq(expected_result)
    end

    it "only sets the rating_to option when only the rating to option is given" do
      Video.set_advanced_search_options("", "5", "", "1")
      expected_result = {
        fields: [{ title: :word_start }, "description^50", "title^100"],
        where: { average_rating: { lte: "5" } },
        page: "1",
        per_page: 20
      }

      expect(Video.instance_variable_get(:@advanced_search_options)).to eq(expected_result)
    end

    it "sets all options when all options are given" do
      Video.set_advanced_search_options("1", "5", "y", "1")
      expected_result = {
        fields: [{ title: :word_start }, "description^50", "title^100", :reviews],
        where: { average_rating: { gte: "1", lte: "5" } },
        page: "1",
        per_page: 20
      }

      expect(Video.instance_variable_get(:@advanced_search_options)).to eq(expected_result)
    end
  end

  describe ".advanced_search" do
    context "with title, description and reviews" do
      it 'returns an an empty array for no match with reviews option' do
        create(:video, title: "Star Wars")
        batman = create(:video, title: "Batman")
        create(:review, video: batman, content: "such a star movie!")
        Video.reindex
        Video.set_advanced_search_options("", "", "y", "1")


        expect(Video.advanced_search("no_match").results).to eq([])
      end

      it 'returns an array of many videos with relevance title > description > review' do
        star_wars = create(:video, title: "Star Wars")
        about_sun = create(:video, title: "Fake Movie", description: "the sun is a star!")
        batman    = create(:video, title: "Batman")
        create(:review, video: batman, content: "such a star movie!")
        Video.reindex
        Video.set_advanced_search_options("", "", "y", "1")

        expect(Video.advanced_search("star").results).to eq([star_wars, about_sun, batman])
      end
    end

    context "filter with average ratings" do
      let(:star_wars_1) { create(:video, title: "Star Wars 1") }
      let(:star_wars_2) { create(:video, title: "Star Wars 2") }
      let(:star_wars_3) { create(:video, title: "Star Wars 3") }

      before do
        create(:review, rating: "2", video: star_wars_1)
        create(:review, rating: "4", video: star_wars_1)
        create(:review, rating: "4", video: star_wars_2)
        create(:review, rating: "2", video: star_wars_3)
        Video.reindex
      end

      context "with only rating_from" do
        it "returns an empty array when there are no matches" do
          Video.set_advanced_search_options("4.1", "", "", "1")

          expect(Video.advanced_search("Star Wars").results).to eq []
        end

        it "returns an array of one video when there is one match" do
          Video.set_advanced_search_options("4.0", "", "", "1")

          expect(Video.advanced_search("Star Wars").results).to eq [star_wars_2]
        end

        it "returns an array of many videos when there are multiple matches" do
          Video.set_advanced_search_options("3.0", "", "", "1")

          expect(Video.advanced_search("Star Wars")).to match_array [star_wars_2, star_wars_1]
        end
      end

      context "with only rating_to" do
        it "returns an empty array when there are no matches" do
          Video.set_advanced_search_options("", "1.5", "", "1")

          expect(Video.advanced_search("Star Wars").results).to eq []
        end

        it "returns an array of one video when there is one match" do
          Video.set_advanced_search_options("", "2.5", "", "1")

          expect(Video.advanced_search("Star Wars").results).to eq [star_wars_3]
        end

        it "returns an array of many videos when there are multiple matches" do
          Video.set_advanced_search_options("", "3.4", "", "1")

          expect(Video.advanced_search("Star Wars")).to match_array [star_wars_1, star_wars_3]
        end
      end

      context "with both rating_from and rating_to" do
        it "returns an empty array when there are no matches" do
          Video.set_advanced_search_options("3.4", "3.9", "", "1")

          expect(Video.advanced_search("Star Wars").results).to eq []
        end

        it "returns an array of one video when there is one match" do
          Video.set_advanced_search_options("1.8", "2.2", "", "1")

          expect(Video.advanced_search("Star Wars").results).to eq [star_wars_3]
        end

        it "returns an array of many videos when there are multiple matches" do
          Video.set_advanced_search_options("2.9", "4.1", "", "1")

          expect(Video.advanced_search("Star Wars")).to match_array [star_wars_1, star_wars_2]
        end
      end
    end
  end
end
