class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :blogs, dependent: :destroy
  has_one_attached :avatar

  normalizes :email, with: -> { it.strip.downcase }
  validates :name, presence: true
end
