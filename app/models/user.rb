class User < ApplicationRecord
  has_secure_password validations: false
  has_many :sessions, dependent: :destroy
  has_many :blogs, dependent: :destroy
  has_one_attached :avatar

  enum :role, { staff: 0, organizer: 1 }

  normalizes :email, with: -> { it.strip.downcase }

  validates :name, presence: true
  validates :password, length: { minimum: 8 }, confirmation: true, allow_nil: true
  validate on: :update do
    errors.add :password, :blank if password_digest.blank?
  end

  generates_token_for :invitation, expires_in: 14.days do
    password_digest&.last 10
  end

  def invited? = password_digest.blank?
end
