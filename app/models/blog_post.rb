class BlogPost < ActiveRecord::Base
  belongs_to :event
  belongs_to :author, class_name: "User"

  validates :title, presence: true
  validates :content, presence: true
end
