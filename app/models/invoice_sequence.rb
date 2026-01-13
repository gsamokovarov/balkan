class InvoiceSequence < ApplicationRecord
  has_many :invoices

  def name = super || initial_number

  def next_invoice_number
    last_invoice_number = invoices.maximum :number
    last_invoice_number ? last_invoice_number + 1 : initial_number
  end
end
