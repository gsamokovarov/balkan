class Speaker < ApplicationRecord
  has_many :talks
  has_one_attached :avatar

  validates :name, presence: true
end
