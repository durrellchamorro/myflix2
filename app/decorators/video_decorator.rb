class VideoDecorator < Draper::Decorator
  delegate_all

  def print_average_video_rating
    return nil if reviews.blank?
    average_video_rating.try(:round, 2)
  end

  private

  def accepted_reviews
    reviews.reject { |review| review.rating.nil? || review.rating == 0 }
  end

  def averagable_reviews_count(reviews_difference)
    reviews_difference >= 1 ? reviews_difference.to_f : reviews.size.to_f
  end

  def average_video_rating
    return nil unless accepted_reviews.present?
    accepted_reviews.map(&:rating).reduce(:+) /
      averagable_reviews_count(reviews.size - accepted_reviews.size)
  end
end
