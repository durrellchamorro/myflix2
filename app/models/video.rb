class Video < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :history

  belongs_to :category
  validates_presence_of :title, :description, :token
  has_many :reviews
  has_many :queue_items
  has_many :photos, dependent: :destroy

  searchkick word_start: [:title]

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where('title ILIKE ?', "%#{search_term}%")
  end

  def search_data
    {
      title: title,
      description: description,
      reviews: reviews.map(&:content),
      average_rating: decorate.print_average_video_rating
    }
  end

  def photo
    photos.first.try(:image_url, public: true)
  end

  def self.advanced_search(query)
    search(
      query,
      @advanced_search_options
    )
  end

  def self.set_advanced_search_options(rating_from, rating_to, reviews, page)
    @advanced_search_options = {
      fields: [{ title: :word_start }, "description^50", "title^100"],
      where: { average_rating: {} },
      page: page,
      per_page: 20
    }

    @advanced_search_options[:fields] << :reviews if reviews == "y"
    @advanced_search_options[:where][:average_rating][:gte] = rating_from if rating_from.present?
    @advanced_search_options[:where][:average_rating][:lte] = rating_to if rating_to.present?
  end

  private

  def should_generate_new_friendly_id?
    title_changed?
  end
end
