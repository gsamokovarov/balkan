class CommunicationDraft < ApplicationRecord
  belongs_to :event
  has_many :communications

  time_as_boolean :sent

  validates :name, presence: true, uniqueness: true
  validates :subject, presence: true, liquid: true
  validates :content, presence: true, liquid: true

  def interpolate_for(email)
    context = {
      "email" => email,
      "event_name" => event.name,
      "event_start_date" => event.start_date.to_s,
      "event_end_date" => event.end_date.to_s,
      "year" => event.start_date.year.to_s,
    }

    {
      subject: Liquid::Template.parse(subject).render(context),
      body: Liquid::Template.parse(content).render(context),
    }
  end

  def deliver(communication)
    recipients = communication.recipients
    recipients.build(event.tickets.map { { email: it.email } }) if communication.to_event?
    recipients.build(event.speakers.map { { email: it.email } }) if communication.to_speakers?
    recipients.build(Subscriber.all.map { { email: it.email } }) if communication.to_subscribers?

    communication.recipients = recipients.uniq { it.email.downcase }
    communication.save!
    communication.deliver
    update! sent_at: Time.current
  end
end
