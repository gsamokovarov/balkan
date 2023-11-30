class Ticket < ApplicationRecord
  SHIRT_SIZES = ['XS', 'S', 'M', 'L', 'XL', 'XXL']

  belongs_to :order

  generates_token_for :event_access

  validates :email, presence: true
  validates :description, presence: true
  validates :name, presence: true
  validates :price, presence: true
  validates :shirt_size, inclusion: { in: SHIRT_SIZES }

  normalizes :email, with: -> { _1.downcase.strip }

  def has_event_access? = order.completed_at?
end
