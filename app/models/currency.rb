module Currency
  extend self

  EXCHANGE_RATE = BigDecimal("1.95583").freeze

  def to_bgn(euro)
    euro * EXCHANGE_RATE
  end
end
