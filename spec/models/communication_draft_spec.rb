require "rails_helper"

RSpec.case CommunicationDraft do
  test "creates draft and sends communication to all recipient types" do
    event = create :event, :balkan2024

    draft = CommunicationDraft.create!(event:,
                                       name: "Welcome Newsletter",
                                       subject: "Welcome to {{ event_name }}!",
                                       content: "Hi {{ email }}, see you in {{ year }}!")

    create(:lineup_member, event:, speaker: create(:speaker, email: "alice@example.com")).speaker
    create(:lineup_member, event:, speaker: create(:speaker, email: "bob@example.com")).speaker
    create(:lineup_member, :pending, event:, speaker: create(:speaker, email: "charlie@example.com")).speaker

    create :subscriber, event:, email: "subscriber1@example.com"
    create :subscriber, event:, email: "subscriber2@example.com"

    ticket_type = create :ticket_type, event:, name: "Regular", price: 100
    order = create(:order, event:)

    create :ticket, :early_bird, ticket_type:, order:, email: "ticket1@example.com", name: "John Doe"
    create :ticket, :early_bird, ticket_type:, order:, email: "ticket2@example.com", name: "Jane Smith"

    communication = draft.communications.new event:, to_speakers: true, to_subscribers: true, to_event: true
    draft.deliver communication

    assert communication.persisted?
    assert_eq communication.recipient_count, 7
    assert_eq communication.recipients.sort, [
      "alice@example.com",
      "bob@example.com",
      "charlie@example.com",
      "subscriber1@example.com",
      "subscriber2@example.com",
      "ticket1@example.com",
      "ticket2@example.com",
    ]
  end

  test "sends to only selected recipient types" do
    event = create :event, :balkan2024

    draft = CommunicationDraft.create!(event:,
                                       name: "Speaker Announcement",
                                       subject: "Important update",
                                       content: "Message for speakers")

    create :lineup_member, event:, speaker: create(:speaker, email: "alice@example.com")
    create :subscriber, event:, email: "subscriber@example.com"

    communication = draft.communications.new to_speakers: true, to_subscribers: false, to_event: false
    draft.deliver communication

    assert_eq communication.recipients, ["alice@example.com"]
  end

  test "renders email with liquid variables" do
    event = create :event, :balkan2024

    draft = CommunicationDraft.create!(event:,
                                       name: "Test Draft",
                                       subject: "Welcome to {{ event_name }}!",
                                       content: "See you in {{ year }}, {{ email }}!")

    rendered = draft.render_for("attendee@example.com")

    assert_eq rendered, subject: "Welcome to Balkan Ruby 2024!",
                        body: "See you in 2024, attendee@example.com!"
  end
end
