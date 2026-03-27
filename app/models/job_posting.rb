class JobPosting < ApplicationRecord
  belongs_to :event
  belongs_to :sponsor
  has_many :contacts, class_name: "JobPostingContact"
  has_many_attached :images

  accepts_nested_attributes_for :contacts

  time_as_boolean :published

  validates :title, presence: true
  validates :description, presence: true

  def self.published = where.not(published_at: nil)
  def self.for(event) = published.where(event:)
end
