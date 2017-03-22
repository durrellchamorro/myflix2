class Video < ActiveRecord::Base
  belongs_to :category
  validates_presence_of :title, :description
  has_many :reviews
  has_many :queue_items

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where('title ILIKE ?', "%#{search_term}%")
  end

  def print_average_video_rating
    return "N/A" if reviews.blank?
    average = reviews.map(&:rating).reduce(:+) / reviews.size.to_f

    average.round(2)
  end
end
