class Speaker < ApplicationRecord
  has_and_belongs_to_many :talks
  has_one_attached :avatar

  validates :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
end
