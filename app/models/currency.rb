module Currency
  extend self

  EUR_TO_BGN_RATE = "1.95583".to_d

  def format_money(eur, locale:)
    if locale == :bg
      "#{to_bgn(eur).round(2, :down)} лв."
    else
      "€#{eur.round(2, :down)}"
    end
  end

  private def to_bgn(eur) = eur * EUR_TO_BGN_RATE
end
