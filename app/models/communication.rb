class Communication < ApplicationRecord
  belongs_to :draft, class_name: "CommunicationDraft", foreign_key: "communication_draft_id"
  has_one :event, through: :draft
  has_many :recipients, class_name: "CommunicationRecipient", dependent: :destroy

  accepts_nested_attributes_for :recipients, allow_destroy: true

  attr_accessor :to_speakers, :to_subscribers, :to_event

  def interpolate_for(email) = draft.interpolate_for email

  def deliver
    recipients.each do
      CommunicationMailer.template_email(self, it.email).deliver_later
    end
  end
end
