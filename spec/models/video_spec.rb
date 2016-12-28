require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe 'search_by_title' do
    it 'returns an empty array if no title matches the search query' do
      Video.create(title: 'Family Guy', description: 'This is a movie about a family and some guy',
                   small_cover_url: '/tmp/family_guy.jpg',
                   large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                   category_id: 1)
      expect(Video.search_by_title('The Matrix')).to eq([])
    end

    it 'returns a video whose title exactly matches the query' do
      video1 = Video.create(title: 'Edward Scissorhands', description: 'This is a movie about a guy with scissors',
                            small_cover_url: '/tmp/family_guy.jpg',
                            large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                            category_id: 1)
      Video.create(title: 'Mia Familia', description: 'This is a movie about a family and some guy',
                   small_cover_url: '/tmp/family_guy.jpg',
                   large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                   category_id: 1)
      Video.create(title: 'asdfFamiaaaaa', description: 'This is a movie about a family and some guy',
                   small_cover_url: '/tmp/family_guy.jpg',
                   large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                   category_id: 1)
      expect(Video.search_by_title('Edward Scissorhands')).to eq([video1])
    end

    it 'returns an array of videos whose title partialy matches the search query ordered by created_at' do
      video1 = Video.create(title: 'Family Guy', description: 'This is a movie about a family and some guy',
                            small_cover_url: '/tmp/family_guy.jpg',
                            large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                            category_id: 1,
                            created_at: 3.days.ago)
      video2 = Video.create(title: 'Mia Familia', description: 'This is a movie about a family and some guy',
                            small_cover_url: '/tmp/family_guy.jpg',
                            large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                            category_id: 1,
                            created_at: 2.days.ago)
      video3 = Video.create(title: 'asdfFamiaaaaa', description: 'This is a movie about a family and some guy',
                            small_cover_url: '/tmp/family_guy.jpg',
                            large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                            category_id: 1,
                            created_at: 1.day.ago)
      expect(Video.search_by_title('Fami')).to eq([video1, video2, video3])
    end

    it 'returns an array of one video when only one video title matches the query' do
      video1 = Video.create(title: 'Family Guy', description: 'This is a movie about a family and some guy',
                            small_cover_url: '/tmp/family_guy.jpg',
                            large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                            category_id: 1)
      Video.create(title: 'The Matrix', description: 'This is a movie about a family and some guy',
                   small_cover_url: '/tmp/family_guy.jpg',
                   large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                   category_id: 1)
      Video.create(title: 'Edward Scissorhands', description: 'This is a movie about a family and some guy',
                   small_cover_url: '/tmp/family_guy.jpg',
                   large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                   category_id: 1)
      expect(Video.search_by_title('Fami')).to eq([video1])
    end

    it 'returns an empty array for a search with an empty string' do
      Video.create(title: 'The Matrix', description: 'This is a movie about a family and some guy',
                   small_cover_url: '/tmp/family_guy.jpg',
                   large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                   category_id: 1)
      Video.create(title: 'Edward Scissorhands', description: 'This is a movie about a family and some guy',
                   small_cover_url: '/tmp/family_guy.jpg',
                   large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                   category_id: 1)

      expect(Video.search_by_title("")).to eq([])
    end

    it 'performs a case insensitive search' do
      video = Video.create(title: 'The Matrix', description: 'This is a movie about the Matrix',
                           small_cover_url: '/tmp/family_guy.jpg',
                           large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                           category_id: 1)

      expect(Video.search_by_title('matrix')).to eq([video])
    end
  end
end
