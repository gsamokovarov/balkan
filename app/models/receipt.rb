class Receipt < ApplicationRecord
  belongs_to :order
  belongs_to :invoice, optional: true, class_name: "Receipt"
  has_many :items, class_name: "ReceiptItem"

  generates_token_for :receipt_access

  enum variant: { invoice: 0, credit_note: 1 }

  scope :invoices, -> { where(variant: :invoice) }
  scope :credit_notes, -> { where(variant: :credit_note) }

  # This is the last invoice we issued for 2020 from the 0010000000 ledger
  LEDGER_START_NUMBER = 1032

  class << self
    def next_number
      (all.maximum(:number) || 0) + 1
    end

    def issue_invoice(order, checkout_session)
      receipt = create!({
        order:,
        number: next_number,
        variant: :invoice,
        issue_date: order.completed_at.to_date,
        tax_event_date: order.completed_at.to_date,
      }.merge(receiver_details(checkout_session.customer_details)))

      order.tickets.each do
        receipt.items.create!(amount: _1.price, ticket: _1)
      end
    end

    private

    def receiver_details(customer_details)
      {
        receiver_name: customer_details&.name || "",
        receiver_email: customer_details&.email || "",
        receiver_company_vat_uid: customer_details&.tax_ids&.[](0)&.value || "",
        receiver_city: customer_details&.address&.city || "",
        receiver_zip: customer_details&.address&.postal_code || "",
        receiver_country: customer_details&.address&.country || "",
        receiver_address: [customer_details&.address&.line1, customer_details&.address&.line2].filter(&:present?).join(" ")
      }
    end
  end

  def receipt_access_url
    Link.receipt_url generate_token_for(:receipt_access)
  end

  def pretty_number
    (LEDGER_START_NUMBER + number).to_s.rjust(8, "0").rjust(10, "0")
  end
end
