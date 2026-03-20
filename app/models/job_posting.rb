class JobPosting < ApplicationRecord
  belongs_to :event
  belongs_to :sponsor
  has_many_attached :images

  time_as_boolean :published

  validates :title, presence: true
  validates :description, presence: true
  validates :application_url, presence: true

  scope :published, -> { where.not(published_at: nil) }
end
