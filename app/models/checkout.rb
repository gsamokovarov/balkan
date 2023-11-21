module Checkout
  extend self

  def create_link(params)
    ActiveRecord::Base.transaction do
      order = ::Order.create!
      tickets = create_tickets(params, order)
      stripe_order = create_stripe_checkout_session(tickets)

      order.update!(stripe_checkout_session_uid: stripe_order.id)

      stripe_order.url
    end
  end

  private

  def create_stripe_checkout_session(tickets)
    Stripe.api_key = ENV.fetch('STRIPE_SECRET_KEY')

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

  def create_tickets(params, order)
    ticket_type = fetch_ticket_type

    params.fetch(:tickets).map do |ticket_params|
      ::Ticket.create!(ticket_params.merge(
        order: order,
        price: ticket_type.price_decimal,
        description: ticket_type.type,
      ))
    end
  end

  def fetch_ticket_type
    ticket_types = TicketType.where(enabled: true).to_a

    raise "One ticket type should be enabled at a time!" if ticket_types.size != 1

    ticket_types.first
  end
end
