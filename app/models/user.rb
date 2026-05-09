class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :blogs, dependent: :destroy
  has_one_attached :avatar

  enum :role, { staff: 0, organizer: 1 }

  normalizes :email, with: -> { it.strip.downcase }
  validates :name, presence: true
end
