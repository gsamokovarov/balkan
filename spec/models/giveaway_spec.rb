require "rails_helper"

RSpec.case Giveaway do
  test "creates a free ticket" do
    event = create :event, :balkan2024
    create(:ticket_type, :free, event:)

    ticket = Giveaway.create_free_ticket event, name: "Genadi", email: "genadi@hey.com", shirt_size: "S"

    assert_eq ticket.name, "Genadi"
    assert_eq ticket.email, "genadi@hey.com"
    assert_eq ticket.shirt_size, "S"

    order = ticket.order
    assert_eq order.email, "genadi@hey.com"
    assert_eq order.name, "Genadi"
    assert_eq order.free?, true
    assert_eq order.free_reason, "Giveaway"
    assert_eq order.completed_at.present?, true
    assert_eq order.amount, 0
  end

  test "creates a free ticket with custom reason" do
    event = create :event, :balkan2024
    create(:ticket_type, :free, event:)

    ticket = Giveaway.create_free_ticket event, name: "Great Person", email: "someone@great.com", shirt_size: "S",
                                                reason: "Basic Sponsorship"

    assert_eq ticket.name, "Great Person"
    assert_eq ticket.email, "someone@great.com"
    assert_eq ticket.shirt_size, "S"

    order = ticket.order
    assert_eq order.free_reason, "Basic Sponsorship"
  end

  test "creates a free tickets in bul" do
    event = create :event, :balkan2024
    create(:ticket_type, :free, event:)

    tickets = Giveaway.create_free_tickets event, [
      { name: "Genadi 1", email: "genadi1@hey.com", shirt_size: "S" },
      { name: "Genadi 2", email: "genadi2@hey.com", shirt_size: "S" },
      { name: "Genadi 3", email: "genadi3@hey.com", shirt_size: "S" },
      { name: "Genadi 4", email: "genadi4@hey.com", shirt_size: "S" }
    ]

    assert_eq tickets[0].name, "Genadi 1"
    assert_eq tickets[0].email, "genadi1@hey.com"
    assert_eq tickets[0].shirt_size, "S"

    assert_eq tickets[1].name, "Genadi 2"
    assert_eq tickets[1].email, "genadi2@hey.com"
    assert_eq tickets[1].shirt_size, "S"

    assert_eq tickets[2].name, "Genadi 3"
    assert_eq tickets[2].email, "genadi3@hey.com"
    assert_eq tickets[2].shirt_size, "S"

    assert_eq tickets[3].name, "Genadi 4"
    assert_eq tickets[3].email, "genadi4@hey.com"
    assert_eq tickets[3].shirt_size, "S"

    order = tickets[0].order
    assert_eq order.email, "genadi1@hey.com"
    assert_eq order.name, "Genadi 1"
    assert_eq order.free?, true
    assert_eq order.free_reason, "Giveaway"
    assert_eq order.completed_at.present?, true
    assert_eq order.amount, 0
  end
end
