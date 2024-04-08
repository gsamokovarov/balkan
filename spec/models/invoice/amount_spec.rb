require "rails_helper"

RSpec.case Invoice::Document do
  test "invoice amount rounding in BGN" do
    amount = Invoice::Document::Amount.new 300, locale: :bg

    assert_eq amount.net, "488.96".to_d
    assert_eq amount.tax, "97.79".to_d
    assert_eq amount.gross, "586.75".to_d
    assert_eq amount.net + amount.tax, amount.gross
  end

  test "invoice amount formatting in BGN" do
    amount = Invoice::Document::Amount.new 288, locale: :bg

    assert_eq amount.net_format, "469.40 лв."
    assert_eq amount.tax_format, "93.88 лв."
    assert_eq amount.gross_format, "563.28 лв."

    assert_eq amount.net_format.to_d + amount.tax_format.to_d, amount.gross_format.to_d
  end
end
