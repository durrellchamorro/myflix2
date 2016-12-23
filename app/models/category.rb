class Category < ActiveRecord::Base
  has_many :videos, -> { order("title") }
  validates_presence_of :name

  # def recent_videos
  #   return [] if self.videos.empty?
  #   videos.reorder(created_at: :desc).slice(0, 6)
  # end
end
