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
end
