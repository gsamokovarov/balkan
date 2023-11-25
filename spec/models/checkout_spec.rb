require 'rails_helper'

RSpec.case Checkout, type: :model do
  test "raises an ActiveRecord::RecordInvalid for invalid ticket data" do
    ticket_type = create_ticket_type

    assert_raise_error ActiveRecord::RecordInvalid do
      Checkout.create_link({ tickets: [{}]}, ticket_type)
    end
  end

  test "returns the stripe chckout url" do
    ticket_type = create_ticket_type
    params = {
      tickets: [
        {
          name: "John Doe",
          email: "john@example.com",
          shirt_size: "XXL",
        }
      ]
    }

    stub_stripe_checkout(
      ticket_type,
      params[:tickets],
      session_id: "stripe-session-id",
      session_url: "https://stripe-checkout-link.com"
    )

    assert_eq Checkout.create_link(params, ticket_type), "https://stripe-checkout-link.com"
  end

  test "returns the stripe chckout url ready to collect invoice data" do
    ticket_type = create_ticket_type
    params = {
      tickets: [
        {
          name: "John Doe",
          email: "john@example.com",
          shirt_size: "XXL",
        }
      ],
      invoice: "1"
    }

    stub_stripe_checkout_with_invoice(
      ticket_type,
      params[:tickets],
      session_id: "stripe-session-id",
      session_url: "https://stripe-checkout-link.com"
    )

    assert_eq Checkout.create_link(params, ticket_type), "https://stripe-checkout-link.com"
  end

  test "creates an order with tickets" do
    ticket_type = create_ticket_type
    params = {
      tickets: [
        {
          name: "John Doe",
          email: "john@example.com",
          shirt_size: "XXL",
        }
      ]
    }

    stub_stripe_checkout(
      ticket_type,
      params[:tickets],
      session_id: "stripe-session-id",
      session_url: "https://stripe-checkout-link.com"
    )

    assert! {
      Checkout.create_link(params, ticket_type)
    }.to change { Order.count }.by(1).and change { Ticket.count }.by(1)

    order = Order.last
    ticket = order.tickets.first

    assert_eq order.stripe_checkout_session_uid, "stripe-session-id"
    assert_eq order.issue_invoice, false
    assert_eq ticket.name, "John Doe"
    assert_eq ticket.price, ticket_type.price
    assert_eq ticket.shirt_size, "XXL"
  end

  test "creates an order with tickets with marked invoice issueing" do
    ticket_type = create_ticket_type
    params = {
      tickets: [
        {
          name: "John Doe",
          email: "john@example.com",
          shirt_size: "XXL",
        }
      ],
      invoice: "1"
    }

    stub_stripe_checkout_with_invoice(
      ticket_type,
      params[:tickets],
      session_id: "stripe-session-id",
      session_url: "https://stripe-checkout-link.com"
    )

    assert! {
      Checkout.create_link(params, ticket_type)
    }.to change { Order.count }.by(1).and change { Ticket.count }.by(1)

    order = Order.last
    ticket = order.tickets.first

    assert_eq order.stripe_checkout_session_uid, "stripe-session-id"
    assert_eq order.issue_invoice, true
    assert_eq ticket.name, "John Doe"
    assert_eq ticket.price, ticket_type.price
    assert_eq ticket.shirt_size, "XXL"
  end

  def create_ticket_type
    OpenStruct.new(
      price: 150,
      type: "Early Bird",
    )
  end
end
