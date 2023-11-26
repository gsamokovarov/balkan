require 'rails_helper'

RSpec.case Checkout, type: :model do
  test ".create_link raises an ActiveRecord::RecordInvalid for invalid ticket data" do
    assert_raise_error ActiveRecord::RecordInvalid do
      Checkout.create_link({ tickets: [{}]}, ticket_type)
    end
  end

  test ".create_link requires at least one ticket to create" do
    assert_raise_error Precondition::Error do
      Checkout.create_link({ tickets: []}, ticket_type)
    end
  end

  test ".create_link returns the stripe checkout url" do
    params = {
      tickets: [name: "John Doe", email: "john@example.com", shirt_size: "XXL"]
    }

    stub_stripe_checkout(
      params[:tickets].map do
        {
          price: ticket_type.price,
          description: "#{ticket_type.type} - #{_1[:name]}"
        }
      end,
      session_id: "stripe-session-id",
      session_url: "https://stripe-checkout-link.com"
    )

    assert_eq Checkout.create_link(params, ticket_type), "https://stripe-checkout-link.com"
  end

  test ".create_link creates an order with tickets" do
    params = {
      tickets: [name: "John Doe", email: "john@example.com", shirt_size: "XXL"]
    }

    stub_stripe_checkout(
      params[:tickets].map do
        {
          price: ticket_type.price,
          description: "#{ticket_type.type} - #{_1[:name]}"
        }
      end,
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
    assert_eq ticket.email, "john@example.com"
    assert_eq ticket.price, ticket_type.price
    assert_eq ticket.shirt_size, "XXL"
  end

  test ".create_link creates an order with 10% discount for 3 or more tickets" do
    params = {
      tickets: [
        { name: "John Doe", email: "john@example.com", shirt_size: "XXL" },
        { name: "Jane Doe", email: "jane@example.com", shirt_size: "XS" },
        { name: "Jake Doe", email: "jake@example.com", shirt_size: "L" }
      ]
    }

    stub_stripe_checkout(
      params[:tickets].map do
        {
          price: ticket_type.price * 0.9,
          description: "#{ticket_type.type} - #{_1[:name]}"
        }
      end,
      session_id: "stripe-session-id",
      session_url: "https://stripe-checkout-link.com"
    )

    assert_change Order, :count do
      assert_change Ticket, :count do
        Checkout.create_link(params, ticket_type)
      end
    end

    order = Order.last
    assert_eq order.stripe_checkout_session_uid, "stripe-session-id"
    assert_eq order.issue_invoice, false

    ticket1, ticket2, ticket3 = order.tickets

    assert_eq ticket1.name, "John Doe"
    assert_eq ticket1.email, "john@example.com"
    assert_eq ticket1.price, ticket_type.price * 0.9
    assert_eq ticket1.shirt_size, "XXL"

    assert_eq ticket2.name, "Jane Doe"
    assert_eq ticket2.email, "jane@example.com"
    assert_eq ticket2.price, ticket_type.price * 0.9
    assert_eq ticket2.shirt_size, "XS"

    assert_eq ticket3.name, "Jake Doe"
    assert_eq ticket3.email, "jake@example.com"
    assert_eq ticket3.price, ticket_type.price * 0.9
    assert_eq ticket3.shirt_size, "L"
  end

  test ".create_link creates an order marked for invoice issuing" do
    params = {
      tickets: [name: "John Doe", email: "john@example.com", shirt_size: "XXL"],
      invoice: "1"
    }

    stub_stripe_checkout_with_invoice(
      params[:tickets].map do
        {
          price: ticket_type.price,
          description: "#{ticket_type.type} - #{_1[:name]}"
        }
      end,
      session_id: "stripe-session-id",
      session_url: "https://stripe-checkout-link.com"
    )

    assert_change Order, :count do
      Checkout.create_link(params, ticket_type)
    end

    order = Order.last

    assert_eq order.stripe_checkout_session_uid, "stripe-session-id"
    assert_eq order.issue_invoice, true
  end

  def ticket_type
    TicketType.find_by! "type": "Early Bird"
  end
end
