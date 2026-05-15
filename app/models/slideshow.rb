class Slideshow < ApplicationRecord
  belongs_to :event
  has_many_attached :images
end
