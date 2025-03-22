class BlogPost < ApplicationRecord
  belongs_to :event
  belongs_to :author, class_name: "User"
  has_one_attached :ogp_image
  has_many_attached :images

  time_as_boolean :published

  validates :title, presence: true
  validates :content, presence: true
  validates :date, presence: true

  def self.published = where.not published_at: nil
end
