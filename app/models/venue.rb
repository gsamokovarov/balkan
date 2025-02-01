class Venue < ApplicationRecord
  has_many :events
  has_many_attached :gallery_images
  has_many_attached :additional_images

  validates :name, presence: true
  validates :description, presence: true
end
