class Category < ApplicationRecord
  has_many :videos, -> { order("title") }
  validates_presence_of :name

  def recent_videos
    return [] if videos.empty?
    videos.reorder(created_at: :desc).to_a.slice(0, 6)
  end
end
