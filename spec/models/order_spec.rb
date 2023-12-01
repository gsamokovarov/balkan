require "rails_helper"

RSpec.describe Order do
  test "#expire! deletes tickets associated with the order" do
    order = create :order, stripe_checkout_session_uid: "test"
    build_list :ticket, 2, :early_bird, order: do |ticket, index|
      ticket.name = "Attendee #{index + 1}"
      ticket.email = "attendee-#{index + 1}@example.com"
      ticket.save!
    end

    order.expire! double(stripe_checkout_session_uid: "test", to_h: {})

    assert_eq order.expired_at?, true
    assert_eq order.tickets, []
    assert_eq Ticket.count, 0
  end

  test "#complete! sends welcome emails" do
    order = create :order, stripe_checkout_session_uid: "test"
    build_list :ticket, 2, :early_bird, order: do |ticket, index|
      ticket.name = "Attendee #{index + 1}"
      ticket.email = "attendee-#{index + 1}@example.com"
      ticket.save!
    end

    order.complete! double(stripe_checkout_session_uid: "test",
                           customer_details: double(email: "test@example.com"),
                           to_h: {})

    assert_eq order.completed_at?, true
  end
end
