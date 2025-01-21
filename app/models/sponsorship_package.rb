class SponsorshipPackage < ApplicationRecord
  belongs_to :event
  has_many :variants, class_name: "SponsorshipVariant", inverse_of: :package

  accepts_nested_attributes_for :variants, destroy_missing: true

  validates :name, presence: true
end
