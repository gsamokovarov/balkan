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

  def issue_refund(amount, invoice_sequence:)
    precondition invoice? && !manual?, "Cannot issue credit note"

    create_refund!(
      invoice_sequence:,
      number: invoice_sequence.next_invoice_number,
      customer_name: order.name,
      receiver_email: order.email,
      customer_address: order.customer_address,
      customer_country: order.customer_country,
      customer_vat_idx: order.customer_vat_idx,
      items_attributes: [
        {
          description_en: I18n.t("invoicing.refund_description", number: prefixed_number, locale: :en),
          description_bg: I18n.t("invoicing.refund_description", number: prefixed_number, locale: :bg),
          unit_price: amount,
        },
      ],
    )
  end

  def prefixed_number = format "%010d", number

  def total_amount = manual? ? items.sum(&:unit_price) : order.amount
  def tax_event_date = order&.completed_at&.to_date || super

  def document(locale:) = Invoice::Document.generate(self, locale:)
  def filename(locale:) = "invoice-#{number}-#{locale}.pdf"

  def customer_details(locale:)
    if manual?
      country = customer_country.present? ? Country[customer_country]&.translations&.[](locale) : nil
      CustomerDetails.new name: customer_name, address: customer_address, country:, vat_id: customer_vat_idx
    else
      name = customer_name || order.name
      address = customer_address || order.customer_address
      country = Country[customer_country || order.customer_country].translations[locale]
      vat_id = customer_vat_idx || order.customer_vat_idx

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
