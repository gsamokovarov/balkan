class Communication < ApplicationRecord
  belongs_to :communication_draft
  has_one :event, through: :communication_draft
  has_many :recipients, class_name: "CommunicationRecipient", dependent: :destroy

  accepts_nested_attributes_for :recipients, allow_destroy: true

  attr_accessor :to_speakers, :to_subscribers, :to_event

  def interpolate_for(email) = communication_draft.interpolate_for email

  def deliver
    recipients.each do
      CommunicationMailer.campaign_email(self, it.email).deliver_later
    end
  end
end
