namespace :orders do
  desc "Import orders with single tickets from Stripe"
  task import: :environment do
    checkout_sessions = JSON.parse Rails.root.join("lib/tasks/checkout_sessions.json").read
    ticket_type = TicketType.enabled.last

    ActiveRecord::Base.transaction do
      checkout_sessions.each do |session|
        tax_ids = session.dig("customer_details", "tax_ids") || []
        tax_id = tax_ids[0]&.dig("value")

        order = Order.create! event: ticket_type.event,
                              email: session["customer_details"]["email"],
                              stripe_checkout_session: session,
                              stripe_checkout_session_uid: session["id"],
                              completed_at: Time.zone.at(session["created"]),
                              pending_tickets: [],
                              issue_invoice: !tax_id.nil?

        # While doing the stripe setup apparently I swapped the keys of the custom fields...
        shirt_size_field = session["custom_fields"].find { _1["key"] == "childcare" }
        attendee_name_field = session["custom_fields"].find { _1["key"] == "tshirtsize" }

        order.tickets.create! ticket_type:,
                              name: attendee_name_field["text"]["value"],
                              email: session["customer_details"]["email"],
                              price: session["amount_total"].to_d / 100,
                              shirt_size: shirt_size_field["dropdown"]["value"].upcase
      end
    end
  end

  desc "Issue invoices for Orders without one"
  task issue_invoices: :environment do
    Order.where.not(completed_at: nil)
      .where(issue_invoice: true)
      .where("NOT EXISTS (SELECT 1 from receipts WHERE receipts.order_id = orders.id)")
      .order(completed_at: :asc)
      .each do
      Receipt.issue_invoice(_1, Stripe::Checkout::Session.construct_from(_1.stripe_checkout_session))
    end
  end
end
