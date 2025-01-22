class Sponsorship < ApplicationRecord
  belongs_to :event
  belongs_to :sponsor
  belongs_to :variant, class_name: "SponsorshipVariant"
end
