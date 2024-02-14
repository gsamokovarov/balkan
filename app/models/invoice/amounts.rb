class Invoice::Amounts
  EUR_TO_BGN_RATE = "1.95583".to_d
  BULGARIAN_VAT = "0.2".to_d

  attr_reader :gross, :net, :tax

  def initialize(gross_in_eur, locale: :en)
    @bulgarian = locale.to_sym == :bg

    @gross = round(@bulgarian ? eur_to_bgn(gross_in_eur) : gross_in_eur)
    @net = round(@gross / (1 + BULGARIAN_VAT))
    @tax = round(@gross - @net)
  end

  def gross_format = format gross
  def net_format = format net
  def tax_format = format tax

  private

  def round(amount) = amount.round 2, :half_even
  def eur_to_bgn(eur) = eur * EUR_TO_BGN_RATE

  def format(amount)
    if @bulgarian
      Kernel.format "%0.2f лв.", amount
    else
      Kernel.format "€%0.2f", amount
    end
  end
end
