class Issuer
  PERIODS = [
    { key: :euruko_2016, duration: Date.new(2016, 1, 1)..Date.new(2017, 7, 9) }, # rubocop:disable Naming/VariableNumber
    { key: :neuvents_todorov, duration: Date.new(2017, 7, 10)..Date.new(2019, 6, 2) },
    { key: :neuvents_mihaylov, duration: Date.new(2019, 6, 3)..Date.new(2024, 3, 11) },
    { key: :neuvents_genadi, duration: Date.new(2024, 3, 12).. },
  ]

  def initialize(date:, locale:)
    @key = PERIODS.find { it[:duration].cover?(date) }.fetch(:key)
    @locale = locale
  end

  def company_name = t(:company_name)
  def address = t(:address)
  def country = t(:country)
  def company_id = t(:company_id)
  def vat_id = t(:vat_id)
  def ceo = t(:ceo)

  private

  def t(attr) = I18n.t("invoicing.issuers.#{@key}.#{attr}", locale: @locale)
end
