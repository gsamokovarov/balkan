class CommunicationDraft < ApplicationRecord
  belongs_to :event, optional: true
  has_many :communications

  validates :name, presence: true, uniqueness: true
  validates :subject, presence: true, liquid: true
  validates :content, presence: true, liquid: true

  def preview(context = {})
    sample_context = {
      "email" => "sample@example.com",
      "event_name" => event&.name || "Sample Conference 2026",
      "event_start_date" => event&.start_date&.to_s || "2026-05-15",
      "event_end_date" => event&.end_date&.to_s || "2026-05-16",
      "year" => event&.start_date&.year&.to_s || "2026",
    }.merge(context.stringify_keys)

    {
      subject: Liquid::Template.parse(subject).render(sample_context),
      body: Liquid::Template.parse(content).render(sample_context),
    }
  end

  def render_for(email, event_context)
    context = {
      "email" => email,
      "event_name" => event_context.name,
      "event_start_date" => event_context.start_date.to_s,
      "event_end_date" => event_context.end_date.to_s,
      "year" => event_context.start_date.year.to_s,
    }

    {
      subject: Liquid::Template.parse(subject).render(context),
      body: Liquid::Template.parse(content).render(context),
    }
  end

  def deliver(communication)
    recipients = communication.communication_recipients
    recipients.build(event.tickets.map { { email: it.email } }) if communication.to_event
    recipients.build(event.speakers.map { { email: it.email } }) if communication.to_speakers
    recipients.build(event.subscribers.map { { email: it.email } }) if communication.to_subscribers

    communication.communication_recipients = recipients.uniq { it.email.downcase }
    communication.save!
    communication.deliver
  end
end
