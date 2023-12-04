require "rails_helper"

RSpec.case Checkout, type: :model do
  test ".create_link raises an ActiveRecord::RecordInvalid for invalid ticket data" do
    ticket_type = create :ticket_type, :enabled

    assert_raise_error ActiveModel::StrictValidationFailed do
      Checkout.create_link tickets: [{}], ticket_type_id: ticket_type.id
    end
  end

  test ".create_link requires at least one ticket to create" do
    ticket_type = create :ticket_type, :enabled

    assert_raise_error Precondition::Error do
      Checkout.create_link tickets: [], ticket_type_id: ticket_type.id
    end
  end

  test ".create_link raises an ActiveRecord::RecordNotFound for disabled ticket type" do
    ticket_type = create :ticket_type

    assert_raise_error ActiveRecord::RecordNotFound do
      Checkout.create_link tickets: [{}], ticket_type_id: ticket_type.id
    end
  end

  test ".create_link returns the stripe checkout url" do
    ticket_type = create :ticket_type, :enabled
    params = {
      tickets: [name: "John Doe", email: "john@example.com", shirt_size: "XXL"],
      ticket_type_id: ticket_type.id
    }

    stub_stripe_checkout(
      params[:tickets].map do
        {
          price: ticket_type.price,
          description: "#{ticket_type.name} - #{_1[:name]}"
        }
      end,
      session_id: "stripe-session-id",
      session_url: "https://stripe-checkout-link.com"
    )

    assert_eq Checkout.create_link(params), "https://stripe-checkout-link.com"
  end

  test ".create_link creates an order with tickets metadata" do
    ticket_type = create :ticket_type, :enabled
    params = {
      tickets: [name: "John Doe", email: "john@example.com", shirt_size: "XXL"],
      ticket_type_id: ticket_type.id
    }

    stub_stripe_checkout(
      params[:tickets].map do
        {
          price: ticket_type.price,
          description: "#{ticket_type.name} - #{_1[:name]}"
        }
      end,
      session_id: "stripe-session-id",
      session_url: "https://stripe-checkout-link.com"
    )

    assert_change Order, :count do
      Checkout.create_link params
    end

    order = Order.last
    ticket = order.pending_tickets.first

    assert_eq order.stripe_checkout_session_uid, "stripe-session-id"
    assert_eq order.issue_invoice, false
    assert_eq ticket["name"], "John Doe"
    assert_eq ticket["email"], "john@example.com"
    assert_eq ticket["price"], "150.0"
    assert_eq ticket["shirt_size"], "XXL"
    assert_eq ticket["ticket_type_id"], ticket_type.id
  end

  test ".create_link creates an order with 10% discount for 3 or more tickets" do
    ticket_type = create :ticket_type, :enabled
    params = {
      tickets: [
        { name: "John Doe", email: "john@example.com", shirt_size: "XXL" },
        { name: "Jane Doe", email: "jane@example.com", shirt_size: "XS" },
        { name: "Jake Doe", email: "jake@example.com", shirt_size: "L" }
      ],
      ticket_type_id: ticket_type.id
    }

    stub_stripe_checkout(
      params[:tickets].map do
        {
          price: ticket_type.price * 0.9,
          description: "#{ticket_type.name} - #{_1[:name]}"
        }
      end,
      session_id: "stripe-session-id",
      session_url: "https://stripe-checkout-link.com"
    )

    assert_change Order, :count do
      Checkout.create_link params
    end

    order = Order.last
    assert_eq order.stripe_checkout_session_uid, "stripe-session-id"
    assert_eq order.issue_invoice, false

    ticket1, ticket2, ticket3 = order.pending_tickets

    assert_eq ticket1["name"], "John Doe"
    assert_eq ticket1["email"], "john@example.com"
    assert_eq ticket1["price"], (ticket_type.price * 0.9).to_s
    assert_eq ticket1["shirt_size"], "XXL"
    assert_eq ticket1["ticket_type_id"], ticket_type.id

    assert_eq ticket2["name"], "Jane Doe"
    assert_eq ticket2["email"], "jane@example.com"
    assert_eq ticket2["price"], (ticket_type.price * 0.9).to_s
    assert_eq ticket2["shirt_size"], "XS"
    assert_eq ticket2["ticket_type_id"], ticket_type.id

    assert_eq ticket3["name"], "Jake Doe"
    assert_eq ticket3["email"], "jake@example.com"
    assert_eq ticket3["price"], (ticket_type.price * 0.9).to_s
    assert_eq ticket3["shirt_size"], "L"
    assert_eq ticket3["ticket_type_id"], ticket_type.id
  end

  test ".create_link creates an order marked for invoice issuing" do
    ticket_type = create :ticket_type, :enabled
    params = {
      tickets: [name: "John Doe", email: "john@example.com", shirt_size: "XXL"],
      ticket_type_id: ticket_type.id,
      invoice: "1"
    }

    stub_stripe_checkout_with_invoice(
      params[:tickets].map do
        {
          price: ticket_type.price,
          description: "#{ticket_type.name} - #{_1[:name]}"
        }
      end,
      session_id: "stripe-session-id",
      session_url: "https://stripe-checkout-link.com"
    )

    assert_change Order, :count do
      Checkout.create_link params
    end

    order = Order.last

    assert_eq order.stripe_checkout_session_uid, "stripe-session-id"
    assert_eq order.issue_invoice, true
  end
end
