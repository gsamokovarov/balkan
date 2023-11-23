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
    ticket_params = {
      name: "John Doe",
      email: "john@example.com",
      shirt_size: "XXL",
    }
    params = { tickets: [ticket_params] }
    stub_stipe(
      ticket_type,
      ticket_params,
      session_id: "stripe-session-id",
      session_url: "https://stripe-checkout-link.com"
    )

    assert_eq Checkout.create_link(params, ticket_type), "https://stripe-checkout-link.com"
  end

  test "creates an order with tickets" do
    ticket_type = create_ticket_type
    ticket_params = {
      name: "John Doe",
      email: "john@example.com",
      shirt_size: "XXL",
    }
    params = { tickets: [ticket_params] }
    stub_stipe(
      ticket_type,
      ticket_params,
      session_id: "stripe-session-id",
      session_url: "https://stripe-checkout-link.com"
    )

    assert! {
      Checkout.create_link(params, ticket_type)
    }.to change { Order.count }.by(1).and change { Ticket.count }.by(1)

    order = Order.last
    ticket = order.tickets.first

    assert_eq order.stripe_checkout_session_uid, "stripe-session-id"
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

  def stub_stipe(ticket_type, ticket_params, session_id:, session_url:)
    stub(Stripe::Checkout::Session).to receive(:create).with({
      currency: "eur",
      success_url: "http://localhost:3000/success",
      cancel_url: "http://localhost:3000/error",
      line_items: [
        {
          price_data: {
            currency: "eur",
            unit_amount: (ticket_type.price * 100).to_i,
            product_data: {
              name: "#{ticket_type.type} - #{ticket_params[:name]}",
            },
          },
          quantity: 1,
        }
      ],
      mode: 'payment',
      billing_address_collection: 'required',
      tax_id_collection: {
        enabled: true
      },
    }).and_return(OpenStruct.new({
      id: session_id,
      url: session_url
    }))
  end
end
