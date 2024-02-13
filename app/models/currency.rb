module Currency
  extend self

  EUR_TO_BGN_RATE = "1.95583".to_d

  def format_money(eur, locale:)
    bulgarian = locale.to_sym == :bg
    unit = bulgarian ? "лв." : "€"
    format = bulgarian ? "%n %u" : "%u%n"
    currency = bulgarian ? eur_to_bgn(eur) : eur
    round_mode = bulgarian ? :down : :half_up

    ActiveSupport::NumberHelper.number_to_currency currency, unit:, locale:, format:, round_mode:
  end

  private def eur_to_bgn(eur) = eur * EUR_TO_BGN_RATE
end
