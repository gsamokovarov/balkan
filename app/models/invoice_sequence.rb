class InvoiceSequence < ApplicationRecord
  belongs_to :event
  has_many :invoices

  def next_invoice_number
    last_invoice_number = invoices.maximum :number
    last_invoice_number ? last_invoice_number + 1 : initial_number
  end
end
