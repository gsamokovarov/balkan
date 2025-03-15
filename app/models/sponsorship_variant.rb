class SponsorshipVariant < ApplicationRecord
  belongs_to :package, class_name: "SponsorshipPackage", inverse_of: :variants
  has_many :sponsorships, foreign_key: :variant_id

  validates :name, presence: true
  validates :price, presence: true
  validates :perks, presence: true

  def display_name = "(#{package.name}) #{name}"

  def spots_taken = sponsorships.size
  def spots_remaining = quantity.to_i - spots_taken

  def fiscal? = price.positive?
  def limited? = quantity.to_i.positive?
  def available? = quantity.to_i <= 0 || spots_taken < quantity
end
