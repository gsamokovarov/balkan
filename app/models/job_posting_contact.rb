class JobPostingContact < ApplicationRecord
  belongs_to :job_posting

  validates :email, presence: true
end
