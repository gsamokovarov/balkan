class CommunicationRecipient < ApplicationRecord
  belongs_to :communication

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, uniqueness: { scope: :communication_id }
end
