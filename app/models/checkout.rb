module Checkout
  extend self

  def create_link(params)
    ApplicationRecord.transaction do
      ticket_type = TicketType.enabled.find params.fetch(:ticket_type_id)

      precondition params[:tickets].present?, "At least 1 ticket needs to be created"

      order = Order.create!(event: ticket_type.event)
      tickets_metadata = build_tickets_metadata(order, params[:tickets], ticket_type:)

      issue_invoice = params[:invoice] == "1"

      stripe_session = create_stripe_checkout_session(tickets_metadata, issue_invoice:)
      order.update!(stripe_checkout_session_uid: stripe_session.id,
                    tickets_metadata:,
                    issue_invoice:)

      stripe_session.url
    end
  end

  private

  def create_stripe_checkout_session(tickets_metadata, issue_invoice:)
    checkout_params = {
      currency: "eur",
      success_url: Link.thanks_url,
      cancel_url: Link.root_url,
      line_items: build_stripe_products(tickets_metadata),
      mode: 'payment',
      allow_promotion_codes: true
    }

    if issue_invoice
      checkout_params[:billing_address_collection] = "required"
      checkout_params[:tax_id_collection] = { enabled: true }
    end

    Stripe::Checkout::Session.create checkout_params
  end

  def build_stripe_products(tickets)
    tickets.map do
      {
        price_data: {
          currency: "eur",
          unit_amount: (_1["price"] * 100).to_i,
          product_data: {
            name: "#{_1["description"]} - #{_1["name"]}",
          },
        },
        quantity: 1,
      }
    end
  end

  def build_tickets_metadata(order, tickets, ticket_type:)
    discounted_price = ticket_type.price * 0.9 if tickets.size >= 3
    tickets_metadata =
      tickets.map do
        ticket = order.tickets.build _1
        ticket.price = discounted_price || ticket_type.price
        ticket.description = ticket_type.name
        ticket.ticket_type = ticket_type

        ticket.validate!

        ticket.attributes.slice "name", "description", "email", "price", "shirt_size", "ticket_type_id"
      end

    order.tickets.reload

    tickets_metadata
  end
end
