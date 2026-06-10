class EventActivity < ApplicationRecord
  belongs_to :event
  has_many_attached :images

  time_as_boolean :published

  validates :content, presence: true

  def self.published = where.not published_at: nil

  def relevant? = published? && Date.current.before?(event.end_date + 1.month)
end
