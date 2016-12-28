require 'spec_helper'
describe Category do
  it { should have_many(:videos).order("title") }

  describe '#recent_videos' do
    it 'returns an empty array if there are no videos in the category' do
      category = Category.new(name: 'TV Comedies')

      expect(category.recent_videos).to eq([])
    end

    it 'returns and reorders array of videos ordered by video created_at descending' do
      category = Category.new(name: 'TV Comedies', id: 1)
      video1 = Video.create(title: 'asdfFamiaaaaa', description: 'This is a movie about a family and some guy',
                            small_cover_url: '/tmp/family_guy.jpg',
                            large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                            category: category,
                            created_at: 6.days.ago)
      video2 = Video.create(title: 'asdfFamiaaaaa', description: 'This is a movie about a family and some guy',
                            small_cover_url: '/tmp/family_guy.jpg',
                            large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                            category: category,
                            created_at: 5.days.ago)
      video3 = Video.create(title: 'asdfFamiaaaaa', description: 'This is a movie about a family and some guy',
                            small_cover_url: '/tmp/family_guy.jpg',
                            large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                            category: category,
                            created_at: 4.days.ago)
      video4 = Video.create(title: 'asdfFamiaaaaa', description: 'This is a movie about a family and some guy',
                            small_cover_url: '/tmp/family_guy.jpg',
                            large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                            category: category,
                            created_at: 3.days.ago)
      video5 = Video.create(title: 'asdfFamiaaaaa', description: 'This is a movie about a family and some guy',
                            small_cover_url: '/tmp/family_guy.jpg',
                            large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                            category: category,
                            created_at: 2.days.ago)
      video6 = Video.create(title: 'asdfFamiaaaaa', description: 'This is a movie about a family and some guy',
                            small_cover_url: '/tmp/family_guy.jpg',
                            large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                            category: category,
                            created_at: 1.day.ago)

      expect(category.recent_videos).to eq([video6, video5, video4, video3, video2, video1])
    end

    it 'returns at most 6 videos' do
      category = Category.create(name: 'TV Comedies')
      Video.create(title: 'asdfFamiaaaaa', description: 'This is a movie about a family and some guy',
                   small_cover_url: '/tmp/family_guy.jpg',
                   large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                   category: category,
                   created_at: 9.days.ago)
      Video.create(title: 'asdfFamiaaaaa', description: 'This is a movie about a family and some guy',
                   small_cover_url: '/tmp/family_guy.jpg',
                   large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                   category: category,
                   created_at: 8.days.ago)
      Video.create(title: 'asdfFamiaaaaa', description: 'This is a movie about a family and some guy',
                   small_cover_url: '/tmp/family_guy.jpg',
                   large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                   category: category,
                   created_at: 7.days.ago)
      Video.create(title: 'asdfFamiaaaaa', description: 'This is a movie about a family and some guy',
                   small_cover_url: '/tmp/family_guy.jpg',
                   large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                   category: category,
                   created_at: 6.days.ago)
      Video.create(title: 'asdfFamiaaaaa', description: 'This is a movie about a family and some guy',
                   small_cover_url: '/tmp/family_guy.jpg',
                   large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                   category: category,
                   created_at: 5.days.ago)
      Video.create(title: 'asdfFamiaaaaa', description: 'This is a movie about a family and some guy',
                   small_cover_url: '/tmp/family_guy.jpg',
                   large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                   category: category,
                   created_at: 4.days.ago)
      Video.create(title: 'asdfFamiaaaaa', description: 'This is a movie about a family and some guy',
                   small_cover_url: '/tmp/family_guy.jpg',
                   large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                   category: category,
                   created_at: 3.days.ago)
      Video.create(title: 'asdfFamiaaaaa', description: 'This is a movie about a family and some guy',
                   small_cover_url: '/tmp/family_guy.jpg',
                   large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                   category: category,
                   created_at: 2.days.ago)
      Video.create(title: 'asdfFamiaaaaa', description: 'This is a movie about a family and some guy',
                   small_cover_url: '/tmp/family_guy.jpg',
                   large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                   category: category,
                   created_at: 1.day.ago)

      expect(category.recent_videos.count).to eq(6)
    end

    it 'returns all videos in category if the number of videos in the category is less than 6 videos' do
      tv_comedies = Category.create(name: 'TV Comedies')
      video1 = Video.create(title: 'asdfFamiaaaaa', description: 'This is a movie about a family and some guy',
                            small_cover_url: '/tmp/family_guy.jpg',
                            large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                            category: tv_comedies,
                            created_at: 3.days.ago)
      video2 = Video.create(title: 'asdfFamiaaaaa', description: 'This is a movie about a family and some guy',
                            small_cover_url: '/tmp/family_guy.jpg',
                            large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                            category: tv_comedies,
                            created_at: 2.days.ago)
      video3 = Video.create(title: 'asdfFamiaaaaa', description: 'This is a movie about a family and some guy',
                            small_cover_url: '/tmp/family_guy.jpg',
                            large_cover_url: "http://dummyimage.com/665x375/000000/00a2ff",
                            category: tv_comedies,
                            created_at: 1.day.ago)

      expect(tv_comedies.recent_videos).to eq([video3, video2, video1])
    end
  end
end
