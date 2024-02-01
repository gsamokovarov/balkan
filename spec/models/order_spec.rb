require "rails_helper"

RSpec.describe Order do
  test "expired orders don't create tickets" do
    ticket_type = create :ticket_type, :enabled
    ticket_params = build_ticket_params(index: 1, price: 150, ticket_type:)
    checkout_session = Stripe::Checkout::Session.construct_from id: "test"

    order = create :order, stripe_checkout_session_uid: "test", pending_tickets: [ticket_params]

    order.expire! checkout_session

    assert_eq order.expired_at?, true
    assert_eq order.tickets, []
    assert_eq Ticket.count, 0
  end

  test "completed orders send welcome emails" do
    ticket_type = create :ticket_type, :enabled
    ticket1_params = build_ticket_params(index: 1, price: 150, ticket_type:)
    ticket2_params = build_ticket_params(index: 2, price: 150, ticket_type:)
    checkout_session = Stripe::Checkout::Session.construct_from(
      id: "test",
      customer_details: { email: "test@example.com" },
      total_details: { amount_discount: 0, amount_shipping: 0, amount_tax: 0 },
      amount_total: 30_000,
    )

    order = create :order, stripe_checkout_session_uid: "test", pending_tickets: [ticket1_params, ticket2_params]

    order.complete! checkout_session

    assert_eq ActionMailer::Base.deliveries.count, 2
    email1, email2 = ActionMailer::Base.deliveries

    assert_eq email1.to, [ticket1_params["email"]]
    assert_eq email1.subject, "Welcome to Balkan Ruby!"

    assert_eq email2.to, [ticket2_params["email"]]
    assert_eq email2.subject, "Welcome to Balkan Ruby!"
  end

  test "completed orders create tickets" do
    ticket_type = create :ticket_type, :enabled
    ticket1_params = build_ticket_params(index: 1, price: 150, ticket_type:)
    ticket2_params = build_ticket_params(index: 2, price: 150, ticket_type:)
    checkout_session = Stripe::Checkout::Session.construct_from(
      id: "test",
      customer_details: { email: "test@example.com" },
      total_details: { amount_discount: 0, amount_shipping: 0, amount_tax: 0 },
      amount_total: 30_000,
    )

    order = create :order, stripe_checkout_session_uid: "test", pending_tickets: [ticket1_params, ticket2_params]

    assert_change Ticket, :count do
      order.complete! checkout_session
    end

    assert_eq order.completed_at?, true
    assert_eq order.amount, "300.0".to_d
    assert_eq order.tickets.count, 2

    ticket1, ticket2 = order.tickets

    assert_eq ticket1.name, ticket1_params["name"]
    assert_eq ticket1.email, ticket1_params["email"]
    assert_eq ticket1.price, ticket1_params["price"].to_d
    assert_eq ticket1.shirt_size, ticket1_params["shirt_size"]
    assert_eq ticket1.ticket_type, ticket_type

    assert_eq ticket2.name, ticket2_params["name"]
    assert_eq ticket2.email, ticket2_params["email"]
    assert_eq ticket2.price, ticket2_params["price"].to_d
    assert_eq ticket2.shirt_size, ticket2_params["shirt_size"]
    assert_eq ticket2.ticket_type, ticket_type
  end

  test "completion fails with ActiveRecord::InvalidForeignKey for missing ticket type" do
    ticket_type = double id: 42
    ticket_params = build_ticket_params(index: 1, price: 150, ticket_type:)
    checkout_session = Stripe::Checkout::Session.construct_from(
      id: "test",
      customer_details: { email: "test@example.com" },
      total_details: { amount_discount: 4500, amount_shipping: 0, amount_tax: 0 },
      amount_total: 15_000,
    )

    order = create :order, stripe_checkout_session_uid: "test", pending_tickets: [ticket_params]

    assert_raise_error ActiveRecord::InvalidForeignKey do
      order.complete! checkout_session
    end
  end

  test "completion creates tickets and applies an incoming promo code discount" do
    ticket_type = create :ticket_type, :enabled
    ticket1_params = build_ticket_params(index: 1, price: 150, ticket_type:)
    ticket2_params = build_ticket_params(index: 2, price: 150, ticket_type:)
    checkout_session = Stripe::Checkout::Session.construct_from(
      id: "test",
      customer_details: { email: "test@example.com" },
      total_details: { amount_discount: 4500, amount_shipping: 0, amount_tax: 0 },
      amount_total: 25_500,
    )

    order = create :order, stripe_checkout_session_uid: "test", pending_tickets: [ticket1_params, ticket2_params]

    assert_change Ticket, :count do
      order.complete! checkout_session
    end

    assert_eq order.completed_at?, true
    assert_eq order.tickets.count, 2
    assert_eq order.amount, "255.0".to_d

    ticket1, ticket2 = order.tickets

    assert_eq ticket1.price, "127.5".to_d
    assert_eq ticket2.price, "127.5".to_d
  end

  test "free orders have empty but valid stripe inferred data" do
    event = create :event, :balkan2024
    order = Order.create! event:, free: true, free_reason: "Giveaway", completed_at: Time.current

    assert_eq order.customer_email, nil
    assert_eq order.customer_name, nil
  end

  test "free orders have zero amounts" do
    event = create :event, :balkan2024
    order = Order.create! event:, free: true, free_reason: "Giveaway", completed_at: Time.current

    assert_eq order.gross_amount, 0
    assert_eq order.net_amount, 0
    assert_eq order.tax_amount, 0
  end

  def build_ticket_params(index:, price:, ticket_type:)
    {
      "name" => "John Doe #{index}",
      "email" => "john-#{index}@example.com",
      "price" => price,
      "shirt_size" => "L",
      "ticket_type_id" => ticket_type.id
    }
  end
end
