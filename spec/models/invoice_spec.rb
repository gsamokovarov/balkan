require "rails_helper"

RSpec.case Invoice do
  test "cannot issue invoices for orders before 2024-02-03" do
    order = create :order, completed_at: Time.new(2024, 2, 2)

    assert_raises Precondition::Error do
      Invoice.issue order
    end
  end

  test "cannot issue invoices for orders that did not request it" do
    order = create :order, completed_at: Time.new(2024, 2, 4), issue_invoice: false

    assert_raises Precondition::Error do
      Invoice.issue order
    end
  end

  test "cannot issue invoices for orders with existing invoice" do
    order = create :order, completed_at: Time.current, issue_invoice: true

    Invoice.issue order

    assert_raises Precondition::Error do
      Invoice.issue order
    end
  end

  test "invoice number start with the initial sequence number" do
    order = create :order, completed_at: Time.current, issue_invoice: true

    invoice = Invoice.issue order

    assert_eq invoice.number, 10_001_049
  end

  test "invoice numbers increment from the initial sequence order" do
    event = create :event, :balkan2024

    order1 = create :order, event:, completed_at: Time.current, issue_invoice: true
    order2 = create :order, event:, completed_at: Time.current, issue_invoice: true
    order3 = create :order, event:, completed_at: Time.current, issue_invoice: true

    invoice1 = Invoice.issue order1
    invoice2 = Invoice.issue order2
    invoice3 = Invoice.issue order3

    assert_eq invoice1.number, 10_001_049
    assert_eq invoice2.number, 10_001_050
    assert_eq invoice3.number, 10_001_051
  end

  test "invoice details accept no tax IDs" do
    order = create :order, stripe_checkout_session_uid: "test",
                           stripe_checkout_session: {
                             id: "test",
                             customer_details: {
                               name: "Test",
                               email: "test@example.com",
                               address: { line1: "Test", city: "Test", postal_code: "1234", country: "BG" },
                               tax_ids: []
                             },
                             total_details: { amount_discount: 0, amount_shipping: 0, amount_tax: 0 },
                             amount_total: 30_000,
                           },
                           issue_invoice: true,
                           completed_at: Time.current

    invoice = Invoice.issue order

    assert_eq invoice.customer(locale: "en").vat_id, nil
  end
end
