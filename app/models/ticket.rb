class Ticket < ApplicationRecord
  SHIRT_SIZES = %w[XS S M L XL XXL].freeze

  belongs_to :order
  belongs_to :ticket_type
  has_one :event, through: :order

  generates_token_for :event_access

  with_options strict: true do
    validates :email, presence: true
    validates :name, presence: true
    validates :price, presence: true
    validates :shirt_size, inclusion: { in: SHIRT_SIZES }
  end

  normalizes :email, with: -> { _1.downcase.strip }

  def event_access_url = Link.with_host(event.host) { Link.ticket_url generate_token_for(:event_access) }
  def qrcode = RQRCode::QRCode.new event_access_url

  def supporter? = ticket_type.supporter?
end
