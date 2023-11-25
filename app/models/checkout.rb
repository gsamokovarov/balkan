module Checkout
  extend self

  def create_link(params, ticket_type)
    ApplicationRecord.transaction do
      order = Order.create!
      tickets = create_tickets(params, order, ticket_type)

      stripe_order = create_stripe_checkout_session(tickets)
      order.update!(stripe_checkout_session_uid: stripe_order.id)

      stripe_order.url
    end
  end

  private

  def create_stripe_checkout_session(tickets)
    Stripe::Checkout::Session.create({
      currency: "eur",
      success_url: "http://localhost:3000/success",
      cancel_url: "http://localhost:3000/error",
      line_items: build_stripe_products(tickets),
      mode: 'payment',
      billing_address_collection: 'required',
      tax_id_collection: {
        enabled: true
      },
      # allow_promotion_codes: true, # TODO: should we support this?
    })
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
    params.fetch(:tickets).map do |ticket_params|
      ::Ticket.create!(ticket_params.merge(
        order: order,
        price: ticket_type.price,
        description: ticket_type.type,
      ))
    end
  end
end
