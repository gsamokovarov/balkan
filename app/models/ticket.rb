class Ticket < ApplicationRecord
  belongs_to :order

  T_SHIRT_SIZES = ['XS', 'S', 'M', 'L', 'XL', 'XXL'].freeze

  validates :email, presence: true
  validates :description, presence: true
  validates :name, presence: true
  validates :price, presence: true
  validates :shirt_size, inclusion: { in: T_SHIRT_SIZES }

  before_validation :sanitize_email

  private

  def sanitize_email
    self.email = email&.downcase&.strip&.presence
  end
end
