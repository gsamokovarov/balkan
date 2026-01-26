require "rails_helper"

RSpec.case Invoice::Document::Amount do
  test "formats amounts including VAT" do
    amount = Invoice::Document::Amount.new 120

    assert_eq amount.gross_format, "€120.00"
    assert_eq amount.net_format, "€100.00"
    assert_eq amount.tax_format, "€20.00"
  end

  test "formats amounts excluding VAT" do
    amount = Invoice::Document::Amount.new 100, includes_vat: false

    assert_eq amount.gross_format, "€100.00"
    assert_eq amount.net_format, "€100.00"
    assert_eq amount.tax_format, "€0.00"
  end

  test "negates amounts for credit notes" do
    amount = Invoice::Document::Amount.new 120, negate: true

    assert_eq amount.gross_format, "€-120.00"
    assert_eq amount.net_format, "€-100.00"
    assert_eq amount.tax_format, "€-20.00"
  end
end
