class SponsorshipPackage < ApplicationRecord
  belongs_to :event
  has_many :sponsorship_package_perks
end
