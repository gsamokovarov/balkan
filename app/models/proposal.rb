class Proposal < ApplicationRecord
  belongs_to :event

  enum :status, [:pending, :accepted, :declined]

  time_as_boolean :notified

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :title, presence: true
end
