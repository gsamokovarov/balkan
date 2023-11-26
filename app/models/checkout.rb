module Checkout
  extend self

  def create_link(params, ticket_type)
    ApplicationRecord.transaction do
      order = Order.create!
      tickets = create_tickets(params, order, ticket_type)

      raise(ArgumentError, "At least 1 ticket needs to be created!") if tickets.size.zero?

      stripe_session = create_stripe_checkout_session(tickets, params)
      order.update!(stripe_checkout_session_uid: stripe_session.id, issue_invoice: issue_invoice?(params))

      stripe_session.url
    end
  end

  private

  def issue_invoice?(params)
    params[:invoice] == "1"
  end

  def create_stripe_checkout_session(tickets, params)
    checkout_params = {
      currency: "eur",
      success_url: Rails.application.routes.url_helpers.thanks_url,
      cancel_url: Rails.application.routes.url_helpers.root_url,
      line_items: build_stripe_products(tickets),
      mode: 'payment'
    }

    if issue_invoice?(params)
      checkout_params[:billing_address_collection] = "required"
      checkout_params[:tax_id_collection] = { enabled: true }
    end

    Stripe::Checkout::Session.create(checkout_params)
  end

  def build_stripe_products(tickets)
    tickets.map do |ticket|
      {
        price_data: {
          currency: "eur",
          unit_amount: (ticket.price * 100).to_i,
          product_data: {
            name: "#{ticket.description} - #{ticket.name}",
          },
        },
        quantity: 1,
      }
    end
  end

  def create_tickets(params, order, ticket_type)
    tickets = params[:tickets]
    discounted_price = ticket_type.price * 0.9 if tickets.size >= 3

    tickets.map do
      Ticket.create! _1 do |ticket|
        ticket.order = order
        ticket.price = discounted_price || ticket_type.price
        ticket.description = ticket_type.type
      end
    end
  end
end
