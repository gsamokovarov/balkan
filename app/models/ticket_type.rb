class TicketType < ApplicationRecord
  belongs_to :event

  scope :enabled, -> { where(enabled: true) }
end
