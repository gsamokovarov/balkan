class Invoice < ApplicationRecord
  Customer = Data.define :name, :address, :country, :vat_id

  belongs_to :invoice_sequence
  belongs_to :order

  validates :number, presence: true, strict: true

  def self.issue(order)
    precondition order.invoicable?, "Order is not invoicable"
    precondition order.invoice.nil?, "Invoice already issued for order"

    invoice_sequence = order.invoice_sequence

    create! order:, invoice_sequence:, number: invoice_sequence.next_invoice_number
  end

  def amount(locale:) = Invoice::Amount.new(order.gross_amount, locale:)
  def document(locale:) = Invoice::PdfDocument.generate(self, locale:)
  def filename(locale:) = "balkanruby-#{number}-#{locale}.pdf"

  def customer(locale:)
    Customer.new name: order.stripe_object.customer_details.name,
                 address: order.stripe_object.customer_details.address.line1,
                 country: Country[order.stripe_object.customer_details.address.country].translations[locale],
                 vat_id: order.stripe_object.customer_details.tax_ids.first.value
  end
end
