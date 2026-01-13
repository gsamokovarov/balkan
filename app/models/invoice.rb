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

  LineItem = Data.define :description, :price

  def self.issue(order, **attributes)
    precondition order.invoicable?, "Order is not invoicable"
    precondition order.invoice.nil?, "Invoice already issued for order"

    invoice_sequence = order.invoice_sequence

    create! order:, **attributes, invoice_sequence:, number: invoice_sequence.next_invoice_number
  end

  def total_amount = manual? ? items.sum(:unit_price) : order.amount
  def tax_event_date = order&.completed_at&.to_date || super

  def document(locale:) = Invoice::Document.generate(self, locale:)
  def filename(locale:) = "invoice-#{number}-#{locale}.pdf"

  def customer_details(locale:)
    if manual?
      country = customer_country ? Country[customer_country].translations[locale] : nil
      CustomerDetails.new name: customer_name, address: customer_address, country:, vat_id: customer_vat_idx
    else
      name = customer_name || order.stripe.customer_details.name
      address =
        customer_address ||
        order.stripe.customer_details.address.line1 ||
        "#{order.stripe.customer_details.address.city} #{order.stripe.customer_details.address.postal_code}"
      country = Country[customer_country || order.stripe.customer_details.address.country].translations[locale]
      vat_id = customer_vat_idx || order.stripe.customer_details.tax_ids.first&.value

      CustomerDetails.new name:, address:, country:, vat_id:
    end
  end

  def line_items(locale:)
    if manual?
      items.map { LineItem.new description: it.description(locale:), price: it.unit_price }
    else
      order.tickets.group_by(&:ticket_type).map do |ticket_type, tickets|
        LineItem.new description: I18n.t("invoicing.tickets", count: tickets.size, type: ticket_type.name, locale:),
                     price: tickets.sum(&:price)
      end
    end
  end
end
