class Sponsorship < ApplicationRecord
  belongs_to :event
  belongs_to :sponsor, -> { with_attached_logo }
  belongs_to :variant, class_name: "SponsorshipVariant"
  has_one :package, through: :variant
  has_one_attached :ogp_image

  def fiscal? = price_paid.positive?
end
