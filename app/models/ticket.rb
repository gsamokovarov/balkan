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

  def event_access_url
    precondition has_event_access?, "Ticket has no event access"

    Link.ticket_url generate_token_for(:event_access)
  end

  def qrcode
    event_access_token = generate_token_for(:event_access)
    RQRCode::QRCode.new Link.ticket_url(event_access_token)
  end
end
