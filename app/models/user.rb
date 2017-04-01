class User < ActiveRecord::Base
  validates_presence_of :full_name, :password_digest, :email
  validates_uniqueness_of :email
  has_many :reviews, -> { order("created_at DESC") }
  has_many :queue_items, -> { order(:position) }
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_secure_password

  def normalize_queue_item_positions
    queue_items.each_with_index do |data, index|
      queue_item = QueueItem.find(data[:id])
      queue_item.update(position: index + 1) if queue_item
    end
  end

  def video_review(video)
    Review.find_by(user: self, video: video).try(:rating)
  end

  def queued_video?(video)
    QueueItem.find_by(user: self, video: video).present?
  end

  def leading_relationships
    Relationship.where(leader_id: id)
  end

  def can_follow?(leader_id)
    (follows?(leader_id) || leader_is_self?(leader_id)) == false
  end

  def follows?(leader_id)
    Relationship.find_by(follower: self, leader_id: leader_id)
  end

  def generate_token
    update_column(:token, SecureRandom.urlsafe_base64)
  end

  private

  def leader_is_self?(leader_id)
    leader_id.to_i == id
  end
end
