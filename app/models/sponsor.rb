class Sponsor < ApplicationRecord
  has_many :sponsorships
  has_many :job_postings
  has_many :events, through: :sponsorships
  has_one_attached :logo

  validates :name, presence: true
end
