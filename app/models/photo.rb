class Photo < ApplicationRecord
  include ImageUploader[:image] # adds an `image` virtual attribute
  belongs_to :video

  validates_presence_of :video
end
