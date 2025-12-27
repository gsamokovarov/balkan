class Communication < ApplicationRecord
  belongs_to :communication_draft
  has_one :event, through: :communication_draft
  has_many :communication_recipients, dependent: :destroy

  accepts_nested_attributes_for :communication_recipients, allow_destroy: true

  attr_accessor :to_speakers, :to_subscribers, :to_event

  def recipients = @recipients ||= communication_recipients.map(&:email)
  def recipient_count = communication_recipients.size

  def render_for(email) = communication_draft.render_for email

  def deliver
    recipients.each { CommunicationMailer.campaign_email(self, it).deliver_later }
  end
end
