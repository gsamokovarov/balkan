class Ticket < ApplicationRecord
  SHIRT_SIZES = ['XS', 'S', 'M', 'L', 'XL', 'XXL']

  belongs_to :order
  belongs_to :ticket_type, optional: true

  generates_token_for :event_access

  with_options strict: true do
    validates :email, presence: true
    validates :name, presence: true
    validates :price, presence: true
    validates :shirt_size, inclusion: { in: SHIRT_SIZES }
  end

  normalizes :email, with: -> { _1.downcase.strip }

  def event_access_url
    precondition order.completed_at?, "Ticket has no event access"

    Link.ticket_url generate_token_for(:event_access)
  end

  def qrcode
    event_access_token = generate_token_for(:event_access)
    RQRCode::QRCode.new Link.ticket_url(event_access_token)
  end
end
