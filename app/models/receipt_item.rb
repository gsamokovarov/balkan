class ReceiptItem < ApplicationRecord
  belongs_to :receipt
  belongs_to :ticket
end
