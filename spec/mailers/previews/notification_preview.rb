require "factory_bot_rails"

# Preview all emails at http://localhost:3000/rails/mailers/ticket
class NotificationPreview < ActionMailer::Preview
  include FactoryBot::Syntax::Methods

  def sale_email
    ticket_type = build :ticket_type, name: "Early Bird", price: 100
    order = build :order, name: "Genadi Samokovarov",
                          email: "genadi@hey.com",
                          completed_at: Time.current,
                          amount: 100,
                          tickets: [build(:ticket, name: "Genadi Samokovarov", email: "genadi@hey.com", ticket_type:)],
                          stripe_checkout_session: {
                            "customer_details" => {
                              "address" => {
                                "city" => "Sofia",
                                "country" => "BG",
                                "line1" => "Garibaldi",
                                "line2" => nil,
                                "postal_code" => "1337",
                                "state" => nil
                              },
                              "email" => "office@company.com",
                              "name" => "Company",
                              "phone" => nil,
                              "tax_exempt" => "none",
                              "tax_ids" => ["type" => "eu_vat", "value" => "BG200000000"]
                            },
                          }

    order.invoice = build :invoice, number: 10_001_049, created_at: Time.current
    order.id = 42_000

    NotificationMailer.sale_email(order).deliver_now
  end
end
