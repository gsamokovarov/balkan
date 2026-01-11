class Invoice < ApplicationRecord
  CustomerDetails = Data.define :name, :address, :country, :vat_id

  belongs_to :invoice_sequence
  belongs_to :order, optional: true
  belongs_to :refunded_invoice, class_name: "Invoice", optional: true
  has_one :refund, class_name: "Invoice", foreign_key: :refunded_invoice_id
  has_many :items, class_name: "InvoiceItem", dependent: :destroy

  accepts_nested_attributes_for :items

  def credit_note? = refunded_invoice_id.present?
  def invoice? = !credit_note?
  def manual? = order.nil?

  validates :number, presence: true, strict: true
  validates :customer_country, inclusion: { in: Country.codes }, allow_nil: true

  def self.issue(order, **attributes)
    precondition order.invoicable?, "Order is not invoicable"
    precondition order.invoice.nil?, "Invoice already issued for order"

    invoice_sequence = order.invoice_sequence

    create! order:, **attributes, invoice_sequence:, number: invoice_sequence.next_invoice_number
  end

  def document(locale:) = Invoice::Document.generate(self, locale:)
  def filename(locale:) = "invoice-#{number}-#{locale}.pdf"

  def customer_details(locale:)
    if manual?
      country = customer_country ? Country[customer_country].translations[locale] : nil
      CustomerDetails.new name: customer_name, address: customer_address, country:, vat_id: customer_vat_id
    else
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

  def total_amount = items.sum(:unit_price)
end
