module Checkout
  extend self

  def create_link(params)
    ticket_type = TicketType.enabled.find params.fetch(:ticket_type_id)

    precondition params[:tickets].present?, "At least 1 ticket needs to be created"

    ApplicationRecord.transaction do
      order = Order.create! event: ticket_type.event
      pending_tickets = build_pending_tickets(order, params[:tickets], ticket_type:)

      issue_invoice = params[:invoice] == "1"
      discount_code = params[:discount_code]

      stripe_session = create_stripe_checkout_session(pending_tickets, issue_invoice:, ticket_type:, discount_code:)

      order.update!(amount: pending_tickets.sum { it["price"] },
                    stripe_checkout_session_uid: stripe_session.id,
                    pending_tickets:,
                    issue_invoice:)

      stripe_session.url
    end
  end

  private

  def create_stripe_checkout_session(pending_tickets, issue_invoice:, ticket_type:, discount_code:)
    checkout_params = {
      currency: "eur",
      success_url: Link.thanks_url,
      cancel_url: Link.root_url,
      line_items: build_stripe_products(pending_tickets, ticket_type),
      mode: "payment",
    }

    promotion_code = Stripe::PromotionCode.list(code: discount_code).data.first&.id if discount_code.present?
    if promotion_code
      checkout_params[:discounts] = [promotion_code:]
    else
      checkout_params[:allow_promotion_codes] = true
    end

    if issue_invoice
      checkout_params[:billing_address_collection] = "required"
      checkout_params[:tax_id_collection] = { enabled: true }
    end

    begin
      Stripe::Checkout::Session.create checkout_params
    rescue Stripe::InvalidRequestError => err
      if err.code == "promotion_code_expired"
        checkout_params.delete :discounts
        checkout_params[:allow_promotion_codes] = true
        Stripe::Checkout::Session.create checkout_params
      else
        raise
      end
    end
  end

  def build_stripe_products(tickets, ticket_type)
    tickets.map do
      {
        price_data: {
          currency: "eur",
          unit_amount: (it["price"] * 100).to_i,
          product_data: {
            name: "#{ticket_type.name} - #{it['name']}",
          },
        },
        quantity: 1,
      }
    end
  end

  def build_pending_tickets(order, tickets, ticket_type:)
    discounted_price = ticket_type.price * 0.9 if tickets.size >= 3
    pending_tickets =
      tickets.map do
        ticket = order.tickets.build it
        ticket.price = discounted_price || ticket_type.price
        ticket.ticket_type = ticket_type

        ticket.validate!

        ticket.attributes.slice "name", "email", "price", "shirt_size", "ticket_type_id"
      end

    order.tickets.reload

    pending_tickets
  end
end
