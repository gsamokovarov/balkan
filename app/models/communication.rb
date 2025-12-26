class Communication < ApplicationRecord
  belongs_to :event
  belongs_to :communication_draft
  has_many :communication_recipients, dependent: :destroy

  accepts_nested_attributes_for :communication_recipients, allow_destroy: true

  attr_accessor :to_speakers, :to_subscribers, :to_event

  def recipients = @recipients ||= communication_recipients.map(&:email)

  def deliver
    recipients.each { CommunicationMailer.campaign_email(self, it).deliver_later }
    update! sent_at: Time.current
  end
end
