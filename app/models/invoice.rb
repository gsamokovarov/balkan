class Invoice < ApplicationRecord
  CustomerDetails = Data.define :name, :address, :country, :vat_id

  belongs_to :invoice_sequence
  belongs_to :order

  validates :number, presence: true, strict: true
  validates :customer_country, inclusion: { in: Country.codes }, allow_nil: true

  def self.issue(order, **attributes)
    precondition order.invoicable?, "Order is not invoicable"
    precondition order.invoice.nil?, "Invoice already issued for order"

    invoice_sequence = order.invoice_sequence

    create! order:, **attributes, invoice_sequence:, number: invoice_sequence.next_invoice_number
  end

  def document(locale:) = Invoice::PdfDocument.generate(self, locale:)
  def filename(locale:) = "balkanruby-#{number}-#{locale}.pdf"

  def customer_details(locale:)
    name = customer_name || order.stripe.customer_details.name
    address =
      customer_address ||
      order.stripe.customer_details.address.line1 ||
      "#{order.stripe.customer_details.address.city} #{order.stripe.customer_details.address.postal_code}"
    country = Country[customer_country || order.stripe.customer_details.address.country].translations[locale]
    vat_id = customer_vat_id || order.stripe.customer_details.tax_ids.first&.value

    CustomerDetails.new name:, address:, country:, vat_id:
  end
end
