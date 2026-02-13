class CommunityPartner < ApplicationRecord
  belongs_to :event
  has_one_attached :logo

  validates :name, presence: true
end
