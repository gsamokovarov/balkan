namespace :orders do
  desc "Import orders with single tickets from Stripe"
  task import: :environment do
    checkout_sessions = JSON.parse(File.read(Rails.root.join("lib/tasks/checkout_sessions.json").to_s))
    ticket_type = TicketType.enabled.last

    ActiveRecord::Base.transaction do
      checkout_sessions.each do
        tax_ids = _1.dig("customer_details", "tax_ids") || []
        tax_id = tax_ids[0]&.dig("value")

        order = Order.create!({
           event: ticket_type.event,
           email: _1["customer_details"]["email"],
           stripe_checkout_session: _1,
           stripe_checkout_session_uid: _1["id"],
           completed_at: Time.zone.at(_1["created"]),
           tickets_metadata: [],
           issue_invoice: !!tax_id
        })

        # While doing the stripe setup apperantly I swaped the keys of the custom fields...
        shirt_size_field = _1["custom_fields"].find { |field| field["key"] == "childcare" }
        attendee_name_field = _1["custom_fields"].find { |field| field["key"] == "tshirtsize" }

        order.tickets.create!({
          ticket_type: ticket_type,
          name: attendee_name_field["text"]["value"],
          email: _1["customer_details"]["email"],
          price: BigDecimal(_1["amount_total"]) / 100,
          shirt_size: shirt_size_field["dropdown"]["value"].upcase ,
        })
      end
    end
  end
end
