class Talk < ApplicationRecord
  has_and_belongs_to_many :speakers

  validates :name, presence: true
end
