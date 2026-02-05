class Communication < ApplicationRecord
  belongs_to :draft, class_name: "CommunicationDraft", foreign_key: "communication_draft_id"
  has_one :event, through: :draft
  has_many :recipients, class_name: "CommunicationRecipient", dependent: :destroy

  accepts_nested_attributes_for :recipients, allow_destroy: true

  attr_accessor :to_speakers, :to_subscribers, :to_event

  def to_speakers? = to_speakers && !to_speakers.in?(ActiveModel::Type::Boolean::FALSE_VALUES)
  def to_subscribers? = to_subscribers && !to_subscribers.in?(ActiveModel::Type::Boolean::FALSE_VALUES)
  def to_event? = to_event && !to_event.in?(ActiveModel::Type::Boolean::FALSE_VALUES)

  def interpolate_for(email) = draft.interpolate_for email

  def deliver
    recipients.each do
      CommunicationMailer.template_email(self, it.email).deliver_later
    end
  end
end
