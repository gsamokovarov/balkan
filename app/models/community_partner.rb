class CommunityPartner < ApplicationRecord
  belongs_to :event
  has_one_attached :logo

  validates :name, presence: true
  validates :url, presence: true

  def self.for(event) = where(event:)
end
