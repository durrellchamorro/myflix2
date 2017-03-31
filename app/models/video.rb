class Video < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :history

  belongs_to :category
  validates_presence_of :title, :description
  has_many :reviews
  has_many :queue_items

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where('title ILIKE ?', "%#{search_term}%")
  end

  def print_average_video_rating
    return nil if reviews.blank?
    average_video_rating.try(:round, 2)
  end

  private

  def should_generate_new_friendly_id?
    title_changed?
  end

  def accepted_reviews
    reviews.reject { |review| review.rating.nil? || review.rating == 0 }
  end

  def averagable_reviews_count(reviews_difference)
    reviews_difference >= 1 ? reviews_difference.to_f : reviews.size.to_f
  end

  def average_video_rating
    if accepted_reviews.present?
      accepted_reviews.map(&:rating).reduce(:+) /
      averagable_reviews_count(reviews.size - accepted_reviews.size)
    else
      nil
    end
  end
end
