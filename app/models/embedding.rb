class Embedding < ApplicationRecord
  belongs_to :event

  validates :name, presence: true
  validates :url, presence: true
end
