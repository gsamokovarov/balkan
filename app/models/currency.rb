module Currency
  extend self

  EUR_TO_BGN_RATE = "1.95583".to_d

  def eur_to_bgn(eur) = eur * EUR_TO_BGN_RATE

  def format_money(eur, locale:)
    currency = bulgarian?(locale) ? eur_to_bgn(eur) : eur
    unit = bulgarian?(locale) ? "лв." : "€"
    format = bulgarian?(locale) ? "%n %u" : "%u%n"
    round_mode = bulgarian?(locale) ? :down : :half_up

    ActiveSupport::NumberHelper.number_to_currency currency, unit:, locale:, format:, round_mode:
  end

  private def bulgarian?(locale) = locale.to_sym == :bg
end
