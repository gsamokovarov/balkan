class Contract < ApplicationRecord
  belongs_to :event
  belongs_to :contract_template

  validates :date, presence: true
  validates :company_name, presence: true
  validates :representative_name, presence: true

  def document = Contract::Document.generate(self)
  def filename = "contract-#{company_name.parameterize}-#{contract_template.name.parameterize}-#{id}.pdf"
  def rendered_content = Liquid::Template.parse(contract_template.content).render(liquid_context)

  private

  def liquid_context
    issuer = Issuer.new date:, locale: :en

    {
      "event_name" => event.name,
      "event_start_date" => event.start_date.strftime("%B %-d, %Y"),
      "event_end_date" => event.end_date.strftime("%B %-d, %Y"),
      "event_dates" => "#{event.start_date.strftime '%B %-d'}-#{event.end_date.strftime '%-d, %Y'}",
      "event_year" => event.start_date.year.to_s,
      "event_venue" => event.venue&.name.to_s,
      "event_venue_address" => event.venue&.address.to_s,
      "price" => format("%.2f", price.to_d),
      "price_with_vat" => format("%.2f", price.to_d * "1.2".to_d),
      "vat_amount" => format("%.2f", price.to_d * "0.2".to_d),
      "vat_percent" => "20",
      "company_name" => company_name.to_s,
      "company_address" => company_address.to_s,
      "company_country" => company_country.to_s,
      "company_vat_id" => company_vat_id.to_s,
      "company_id_number" => company_id_number.to_s,
      "representative_name" => representative_name.to_s,
      "issuer_company_name" => issuer.company_name,
      "issuer_address" => issuer.address,
      "issuer_country" => issuer.country,
      "issuer_company_id" => issuer.company_id,
      "issuer_vat_id" => issuer.vat_id,
      "issuer_ceo" => issuer.ceo,
      "date" => date&.strftime("%d.%m.%Y").to_s,
      "payment_deadline" => (date + 15.days).strftime("%d.%m.%Y"),
      "materials_deadline" => (event.start_date - 2.weeks).strftime("%d.%m.%Y"),
      "perks" => perks.to_s,
    }
  end
end
