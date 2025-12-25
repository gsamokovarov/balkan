class Communication < ApplicationRecord
  belongs_to :event
  belongs_to :communication_template, optional: true
  has_many :communication_recipients, dependent: :destroy

  accepts_nested_attributes_for :communication_recipients, allow_destroy: true

  enum :status, { draft: "draft", sending: "sending", sent: "sent" }, validate: true

  validates :subject, presence: true, liquid: true
  validates :content, presence: true, liquid: true

  # Virtual attributes for recipient selection
  attr_accessor :include_subscribers, :include_ticket_holders, :include_speakers, :event_ids, :custom_recipients_text

  before_validation :build_recipients_from_filters, if: -> { draft? && has_filter_changes? }

  def self.drafts = where(status: "draft")
  def self.sent = where(status: "sent")

  def recipients = @recipients ||= communication_recipients.map(&:email)
  def recipient_count = @recipient_count ||= communication_recipients.size

  def has_filter_changes?
    include_subscribers.present? || include_ticket_holders.present? || include_speakers.present? ||
    event_ids.present? || custom_recipients_text.present?
  end

  def build_recipients_from_filters
    emails = Set.new
    selected_events = Event.where(id: Array(event_ids).reject(&:blank?))

    # Subscribers
    if include_subscribers == "1" && selected_events.any?
      if include_ticket_holders == "1"
        # Use union query to avoid duplicates
        emails.merge(Subscriber.including_ticket_holders(*selected_events).pluck(:email))
      else
        # Just subscribers
        emails.merge(Subscriber.where(event: selected_events).pluck(:email))
      end
    elsif include_ticket_holders == "1" && selected_events.any?
      # Just ticket holders
      emails.merge(
        Ticket.joins(:order)
              .where(order: { event_id: selected_events.map(&:id) })
              .pluck(:email)
      )
    end

    # Speakers
    if include_speakers == "1" && selected_events.any?
      emails.merge(
        Speaker.joins(:lineup_members)
               .where(lineup_members: { event_id: selected_events.map(&:id), status: :confirmed })
               .pluck(:email)
               .compact
      )
    end

    # Custom recipients
    if custom_recipients_text.present?
      custom_emails = custom_recipients_text
        .split(/[,\n]/)
        .map(&:strip)
        .select { |email| email.match?(URI::MailTo::EMAIL_REGEXP) }

      emails.merge(custom_emails)
    end

    # Build communication_recipients from emails
    emails.each do |email|
      communication_recipients.build(email: email) unless communication_recipients.any? { |r| r.email == email }
    end

    emails.to_a.sort
  end

  def render_for(email)
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

  def deliver!
    return if !draft? || recipient_count.zero?

    update! status: "sending"

    communication_recipients.each do |recipient|
      CommunicationMailer.campaign_email(self, recipient.email).deliver_later
    end

    update! status: "sent", sent_at: Time.current
  rescue err
    update! status: "draft", error_message: "Delivery failed: #{err.message}"
    raise
  end
end
