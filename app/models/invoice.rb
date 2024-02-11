class Invoice < ApplicationRecord
  ISSUING_START_DATE = Date.new 2024, 2, 3

  belongs_to :invoice_sequence
  belongs_to :order

  validates :number, presence: true, strict: true

  def self.issue(order)
    precondition order.issue_invoice?, "No invoice requested for order"
    precondition order.completed_at.after?(ISSUING_START_DATE), "Cannot invoice orders before #{ISSUING_START_DATE}"
    precondition order.invoice.nil?, "Invoice already issued for order"

    invoice_sequence = order.invoice_sequence

    create! order:, invoice_sequence:, number: invoice_sequence.next_invoice_number
  end
end
