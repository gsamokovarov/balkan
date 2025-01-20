class Sponsorship < ApplicationRecord
  belongs_to :event
  belongs_to :sponsor
  belongs_to :package
end
