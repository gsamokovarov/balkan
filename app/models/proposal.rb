class Proposal < ApplicationRecord
  belongs_to :event

  enum :status, [:pending, :accepted, :declined]

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :title, presence: true
end
