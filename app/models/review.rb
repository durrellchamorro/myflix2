class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  validates_presence_of :content
  validates_presence_of :user_id
  validates_presence_of :video_id
  validates_presence_of :rating
  validate :one_review_per_video_for_user

  after_commit :reindex_video

  def self.valid_reviews(video)
    Review.where(video: video).reject { |review| review.rating == 0 || review.rating.nil? }
  end

  private

  def one_review_per_video_for_user
    errors.add(:rating, "You have already reviewed this video.") if user_already_reviewed?
  end

  def user_already_reviewed?
    Review.where(user: user, video: video).present?
  end

  def reindex_video
    video.reindex
  end
end
