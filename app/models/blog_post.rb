class BlogPost < ApplicationRecord
  belongs_to :event
  belongs_to :author, class_name: "User"

  time_as_boolean :published

  def self.published = where.not published_at: nil

  validates :title, presence: true
  validates :content, presence: true
  validates :date, presence: true
end
