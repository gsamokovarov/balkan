class InvoiceSequence < ApplicationRecord
  has_many :invoices

  def display_name = name ? "#{name} (#{format('%010d', initial_number)}" : format("%010d", initial_number)

  def next_invoice_number
    last_invoice_number = invoices.maximum :number
    last_invoice_number ? last_invoice_number + 1 : initial_number
  end
end
