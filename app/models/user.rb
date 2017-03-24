class User < ActiveRecord::Base
  validates_presence_of :full_name, :password_digest, :email
  validates_uniqueness_of :email
  has_many :reviews
  has_many :queue_items, -> { order(:position) }
  has_secure_password

  def normalize_queue_item_positions
    queue_items.each_with_index do |data, index|
      queue_item = QueueItem.find(data[:id])
      queue_item.update(position: index + 1) if queue_item
    end
  end
end
