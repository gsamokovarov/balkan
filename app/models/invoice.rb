class Invoice < ApplicationRecord
  belongs_to :invoice_sequence
  belongs_to :order

  validates :number, presence: true, strict: true

  def self.issue(order)
    precondition order.invoicable?, "Order is not invoicable"
    precondition order.invoice.nil?, "Invoice already issued for order"

    invoice_sequence = order.invoice_sequence

    create! order:, invoice_sequence:, number: invoice_sequence.next_invoice_number
  end

  def document(locale:) = Invoice::PdfDocument.generate(self, locale:)
  def filename(locale:) = "balkanruby-#{number}-#{locale}.pdf"
end
