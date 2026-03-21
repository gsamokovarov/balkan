class JobPosting < ApplicationRecord
  belongs_to :event
  belongs_to :sponsor
  has_many_attached :images

  time_as_boolean :published

  validates :title, presence: true
  validates :description, presence: true
  validates :application_url, presence: true

  def self.published = where.not(published_at: nil)
  def self.for(event) = published.where(event:)
end
