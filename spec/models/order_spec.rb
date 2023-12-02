require "rails_helper"

RSpec.describe Order do
  test "#expire! does not create tickets" do
    ticket_params = build_ticket_params(index: 1, price: 150)
    order = create :order, stripe_checkout_session_uid: "test", tickets_metadata: [ticket_params]

    order.expire! double(stripe_checkout_session_uid: "test", to_h: {})

    assert_eq order.expired_at?, true
    assert_eq order.tickets, []
    assert_eq Ticket.count, 0
  end

  test "#complete! sends welcome emails" do
    ticket1_params = build_ticket_params(index: 1, price: 150)
    ticket2_params = build_ticket_params(index: 2, price: 150)

    order = create :order, stripe_checkout_session_uid: "test", tickets_metadata: [ticket1_params, ticket2_params]

    order.complete! double(stripe_checkout_session_uid: "test",
                            customer_details: double(email: "test@example.com"),
                            to_h: {})


    assert_eq ActionMailer::Base.deliveries.count, 2
    email1, email2 = ActionMailer::Base.deliveries

    assert_eq email1.to, [ticket1_params["email"]]
    assert_eq email1.subject, "Welcome to Balkan Ruby!"
    assert_eq email2.to, [ticket2_params["email"]]
    assert_eq email2.subject, "Welcome to Balkan Ruby!"
  end

  test "#complete! creates tickets" do
    ticket1_params = build_ticket_params(index: 1, price: 150)
    ticket2_params = build_ticket_params(index: 2, price: 150)

    order = create :order, stripe_checkout_session_uid: "test", tickets_metadata: [ticket1_params, ticket2_params]

    assert_change Ticket, :count do
      order.complete! double(stripe_checkout_session_uid: "test",
                             customer_details: double(email: "test@example.com"),
                             to_h: {})
    end

    assert_eq order.completed_at?, true
    assert_eq order.tickets.count, 2

    ticket1, ticket2 = order.tickets

    assert_eq ticket1.name, ticket1_params["name"]
    assert_eq ticket1.email, ticket1_params["email"]
    assert_eq ticket1.description, ticket1_params["description"]
    assert_eq ticket1.price, BigDecimal(ticket1_params["price"])
    assert_eq ticket1.shirt_size, ticket1_params["shirt_size"]

    assert_eq ticket2.name, ticket2_params["name"]
    assert_eq ticket2.email, ticket2_params["email"]
    assert_eq ticket2.description, ticket2_params["description"]
    assert_eq ticket2.price, BigDecimal(ticket2_params["price"])
    assert_eq ticket2.shirt_size, ticket2_params["shirt_size"]
  end

  def build_ticket_params(index:, price:)
    {
      "name" => "John Doe #{index}",
      "description" => "Early Bird",
      "email" => "john-#{index}@example.com",
      "price" => price.to_s,
      "shirt_size" => "L"
    }
  end
end
