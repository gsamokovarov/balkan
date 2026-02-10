class Proposal < ApplicationRecord
  belongs_to :event

  time_as_boolean :notified
  enum :status, [:pending, :accepted, :declined]

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :title, presence: true

  generates_token_for :access

  def access_url = Link.proposal_url generate_token_for(:access)
end
