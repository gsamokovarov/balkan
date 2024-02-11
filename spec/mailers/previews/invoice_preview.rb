require "factory_bot_rails"

# Preview all emails at http://localhost:3000/rails/mailers/ticket
class InvoicePreview < ActionMailer::Preview
  include FactoryBot::Syntax::Methods

  def issue_email
    order = build :order, name: "Genadi Samokovarov",
                          email: "genadi@hey.com",
                          completed_at: Time.current,
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

    InvoiceMailer.issue_email(order).deliver_now
  end
end
