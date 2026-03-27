class JobPostingContact < ApplicationRecord
  belongs_to :job_posting

  validates :email, presence: true

  def display_name = name.present? ? "#{name} (#{email})" : email
end
