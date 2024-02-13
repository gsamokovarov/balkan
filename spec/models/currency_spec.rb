require "rails_helper"

RSpec.case Currency do
  test "converts EUR to BGN by Bulgarian National Bank rate" do
    assert_eq Currency.eur_to_bgn(1), "1.95583".to_d
  end

  test "formats money in EUR" do
    assert_eq Currency.format_money("1.2".to_d, locale: :en), "€1.20"
  end

  test "formats money in BGN" do
    assert_eq Currency.format_money("1.2".to_d, locale: :bg), "2.34 лв."
  end
end
