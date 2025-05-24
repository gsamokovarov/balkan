class MediaGallery < ApplicationRecord
  belongs_to :event
  has_many_attached :highlights

  validates :videos_url, presence: true
end
