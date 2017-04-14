require 'spec_helper'
describe Category do
  it { should have_many(:videos).order("title") }

  describe '#recent_videos' do
    it 'returns an empty array if there are no videos in the category' do
      category = Category.new(name: 'TV Comedies')

      expect(category.recent_videos).to eq([])
    end

    it 'returns and reorders array of videos ordered by video created_at descending' do
      category = create(:category)
      video1 = create(:video, created_at: 6.days.ago, category: category)
      video2 = create(:video, created_at: 5.days.ago, category: category)
      video3 = create(:video, created_at: 4.days.ago, category: category)
      video4 = create(:video, created_at: 3.days.ago, category: category)
      video5 = create(:video, created_at: 2.days.ago, category: category)
      video6 = create(:video, created_at: 1.day.ago, category: category)

      expect(category.recent_videos).to eq([video6, video5, video4, video3, video2, video1])
    end

    it 'returns at most 6 videos' do
      category = Category.create(name: 'TV Comedies')
      create(:video, created_at: 9.days.ago, category: category)
      create(:video, created_at: 8.days.ago, category: category)
      create(:video, created_at: 7.day.ago, category: category)
      create(:video, created_at: 6.days.ago, category: category)
      create(:video, created_at: 5.days.ago, category: category)
      create(:video, created_at: 4.days.ago, category: category)
      create(:video, created_at: 3.days.ago, category: category)
      create(:video, created_at: 2.days.ago, category: category)
      create(:video, created_at: 1.day.ago, category: category)

      expect(category.recent_videos.count).to eq(6)
    end

    it 'returns all videos in category if the number of videos in the category is less than 6 videos' do
      tv_comedies = Category.create(name: 'TV Comedies')
      video1 = create(:video, created_at: 3.days.ago, category: tv_comedies)
      video2 = create(:video, created_at: 2.days.ago, category: tv_comedies)
      video3 = create(:video, created_at: 1.day.ago, category: tv_comedies)

      expect(tv_comedies.recent_videos).to match_array([video3, video2, video1])
    end
  end
end
