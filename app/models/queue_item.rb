class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  delegate :category, to: :video

  validates_numericality_of :position, only_integer: true 

  def video_title
    video.title
  end

  def rating
    video.print_average_video_rating
  end

  def category_name
    category.name
  end
end
