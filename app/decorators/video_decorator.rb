class VideoDecorator < Draper::Decorator
  delegate_all

  def print_average_video_rating
    return nil if reviews.blank?
    average_video_rating.try(:round, 2)
  end

  def youtube_iframe
    "<iframe width='854' height='480' src='https://www.youtube.com/embed/#{token}' frameborder='0' allowfullscreen></iframe>".html_safe
  end

  def add_to_queue_button(current_user)
    return if current_user.queued_video?(self)
    "<a class='btn btn-primary' data-method='post' href='/queue_items?video_slug=#{slug}'>+ My Queue</a>".html_safe
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
