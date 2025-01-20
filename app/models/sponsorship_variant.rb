class SponsorshipVariant < ApplicationRecord
  belongs_to :package, class_name: "SponsorshipPackage", inverse_of: :variants

  validates :name, presence: true
  validates :price, presence: true
  validates :perks, presence: true
end
