require "rails_helper"

RSpec.case Invoice::PdfDocument do
  test "invoice amount rounding in BGN" do
    amount = Invoice::PdfDocument::Amount.new 300, locale: :bg

    assert_eq amount.net, "488.96".to_d
    assert_eq amount.tax, "97.79".to_d
    assert_eq amount.gross, "586.75".to_d
    assert_eq amount.net + amount.tax, amount.gross
  end

  test "invoice amount formatting in BGN" do
    amount = Invoice::PdfDocument::Amount.new 288, locale: :bg

    assert_eq amount.net_format, "469.40 лв."
    assert_eq amount.tax_format, "93.88 лв."
    assert_eq amount.gross_format, "563.28 лв."

    assert_eq amount.net_format.to_d + amount.tax_format.to_d, amount.gross_format.to_d
  end

  test "invoice customer details can lack tax ID" do
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

    customer_details = Invoice::PdfDocument::CustomerDetails.from_order order, locale: "en"

    assert_eq customer_details.vat_id, nil
  end
end
