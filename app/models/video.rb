class Video < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :history

  belongs_to :category
  validates_presence_of :title, :description, :token
  has_many :reviews
  has_many :queue_items
  has_many :photos, dependent: :destroy


  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where('title ILIKE ?', "%#{search_term}%")
  end

  private

  def should_generate_new_friendly_id?
    title_changed?
  end
end
